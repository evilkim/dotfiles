function prompt_status {
    # highlight non-zero return code / exit status
    # https://stackoverflow.com/questions/5947742\
	# /how-to-change-the-output-color-of-echo-in-linux
    local rc=${?}
    if ((rc)); then
	local red=$'\e[0;31m' reset=$'\e[0m'
	echo "${red}[RC=${rc}]${reset}"
    fi
    return ${rc}
}

PROMPT_COMMAND="prompt_status;${PROMPT_COMMAND}"
