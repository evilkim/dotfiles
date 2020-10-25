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

: ${pd:="${HOME}/.pd.d"}  # Allow override for use on NFS mounted HOME

if [[ -e "${pd}/debug" ]]; then
    pd_debug='echo >&2 "${BASH_SOURCE}: ${FUNCNAME} ${*}"'
else
    pd_debug=""
fi

function cd {
    eval ${pd_debug}
    builtin cd "${@}" >/dev/null
    dirs
}

function dirs {
    eval ${pd_debug}
    builtin dirs -l -p >| "${pd}/dirstack"
    builtin dirs -v
}

function pushd {
    eval ${pd_debug}
    builtin pushd "${@}" >/dev/null
    dirs
}

function popd {
    eval ${pd_debug}
    builtin popd "${@}" >/dev/null
    dirs
}

function pd_nonce {
    # Initialize DIRSTACK from ${pd}/dirstack once per shell
    eval ${pd_debug}
    if [[ ${#DIRSTACK[@]} == 1 ]]; then
	mkdir -p "${pd}"
	touch "${pd}/dirstack"
	declare -A seen=(["${PWD}"]=exists)
	local dir
	while read dir; do
	    if [[ ! "${seen["${dir}"]+duplicate}" ]]; then
		seen["${dir}"]=exists
		builtin pushd -n "${dir}" >/dev/null
	    fi
	done <<< $(tac "${pd}/dirstack") # cat in reverse
    fi
    function pd_nonce { :; }
}

function pd {
    pd_nonce
    eval ${pd_debug}
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
