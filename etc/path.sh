# Pre-pend PATH with ~/bin IFF missing
case ":${PATH}:" in
    *:${HOME}/bin:*)
	: ;;
    *)
	PATH="${HOME}/bin:${PATH}";;
esac

function path_dedup {
    local path=""
    declare -A seen
    local entry
    while read entry; do
	if [[ "${seen["${entry}"]+duplicate}" ]]; then
	    echo >&2 -e "${BASH_SOURCE}: duplicate PATH entry '${entry}'"
	else
	    path+="${path:+:}${entry}"
	    seen["${entry}"]=exists
	fi
    done <<< $(echo -e "${PATH//:/\\n}")
    if [[ "${path}" != "${PATH}" ]]; then PATH="${path}"; fi
}

path_dedup

alias path='echo -e ${PATH//:/\\n}'
