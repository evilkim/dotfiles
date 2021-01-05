#!/bin/bash
# HELP - "Persistent Dirs" augments cd, dirs, popd, and pushd
#
# SYNOPSIS
# * cd [ARGS]		cd [ARGS]
# * pd =		dirs
# * pd [+] [ARGS]	pushd [ARGS]
# * pd +N		pushd +N
# * pd - [ARGS]		popd [ARGS]
# * pd -N		popd +N

# Override dirstack location as desired to share across NFS mounted HOME
: ${pd:="${HOME}/.pd.d/${HOSTNAME}.${OSTYPE}"}

# touch/rm "${pd}/debug" to enable/disable debugging
pd_debug='[[ -e "${pd}/debug" ]] &&'
pd_debug+=' echo >&2 "${BASH_SOURCE}: ${FUNCNAME} ${*}" || :'

# pd is interactive - do not redefine cd, dirs, popd, pushd in subshells
_pd_eval='[[ "${BASH_SUBSHELL}" == 0 ]] || '
_pd_eval+='{ builtin "${FUNCNAME}" "${@}"; return; };'
_pd_eval+="${pd_debug}"

function cd {
    eval ${_pd_eval}
    builtin cd "${@}" >/dev/null
    dirs
}

function dirs {
    eval ${_pd_eval}
    builtin dirs -l -p >| "${pd}/dirstack"
    builtin dirs -v
}

function pushd {
    eval ${_pd_eval}
    builtin pushd "${@}" >/dev/null
    dirs
}

function popd {
    eval ${_pd_eval}
    builtin popd "${@}" >/dev/null
    dirs
}

function _pd_nonce {
    # Initialize DIRSTACK from ${pd}/dirstack once per shell
    function _pd_nonce { :; }
    eval ${pd_debug}
    if [[ ${#DIRSTACK[@]} == 1 ]]; then
	mkdir -p "${pd}"
	touch "${pd}/dirstack"
	declare -A seen=(["${PWD}"]=exists)
	local dir
	tac "${pd}/dirstack" |  # cat in reverse
	    while read dir; do
	        if [[ ! "${seen["${dir}"]+duplicate}" ]]; then
		    seen["${dir}"]=exists
		    builtin pushd -n "${dir}" >/dev/null
	        fi
	    done
    fi
}

function pd {
    eval ${_pd_eval}
    _pd_nonce
    case "${1:-}" in
        '=')
	    if [[ ${#} != 1 ]]; then
		shift
		echo >&2 "${BASH_SOURCE}: Too many args: ${*}"
		return 2
	    fi
	    dirs
	    ;;
        '-') shift; popd "${@}";;
        '+') shift; pushd "${@}";;
        '+'[0-9] | '+'[1-9][0-9])
	    if [[ ${#} != 1 ]]; then
		shift
		echo >&2 "${BASH_SOURCE}: Too many args: ${*}"
		return 2
	    fi
	    pushd "${1}"
	    ;;
        '-'[0-9] | '-'[1-9][0-9])
	    if [[ ${#} != 1 ]]; then
		shift
		echo >&2 "${BASH_SOURCE}: Too many args: ${*}"
		return 2
	    fi
	    local N="${1/-/+}"; popd "+${N}"
	    ;;
        *) pushd "${@}";;
    esac
}
