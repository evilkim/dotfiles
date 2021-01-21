echo >&2 "${BASH_SOURCE}: ENTER" # Uncomment to help isolate any errors
#-----------------------------------------------------------------------------#

function bashrc {
    # Wrapped in function so local variables don't pollute the shell
    local custom=()

    # localized system-wide defaults (optional)
    local skel="/etc/skel/.bashrc"
    if [[ -f "${skel}" ]]; then
	custom=("${skel}")
	diff --brief /etc/defaults/"${skel}" "${skel}" # has it skewed?
    fi

    # per user add-ons
    if [[ "${-}" = *i* ]]; then
	# full interactive customization
	custom+=(~/etc/*.sh)
	if compgen -G ~/etc/${OSTYPE}/\*.sh; then
	    custom+=(~/etc/${OSTYPE}/*.sh) # vendor-specific config if any
	fi
	if compgen -G ~/etc/local.d/\*.sh; then
	    custom+=(~/etc/local.d/*.sh) # local config if any (not shared)
	fi
    else
	# selective non-interactive customization
	custom+=(~/etc/{env,path}.sh)
    fi
    local file
    for file in "${custom[@]}"; do
	echo >&2 "${file}: ENTER"
	source "${file}"
	#echo >&2 "${file}: LEAVE"
    done
}

bashrc
unset -f bash

#-----------------------------------------------------------------------------#
#echo >&2 "${BASH_SOURCE}: LEAVE"
