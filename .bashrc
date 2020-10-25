echo >&2 "${BASH_SOURCE}: ENTER"
#-----------------------------------------------------------------------------#

function bashrc {
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
	if compgen -G "${HOME}/etc/${OSTYPE}/*.sh"; then
	    custom+=(~/etc/${OSTYPE}/*.sh) # vendor-specific config if any
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

bashrc				# equivalent to source ~/.bashrc

#-----------------------------------------------------------------------------#
#echo >&2 "${BASH_SOURCE}: LEAVE"
