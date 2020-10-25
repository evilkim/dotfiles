alias ls='ls -F --color=auto --show-control-chars'

alias ll='ls -lAF'

function ltt {
    # List Top Ten files by modified time
    local window=10		# 10 lines per "window"
    ll -t "${@}" |
        if which more >& /dev/null; then
            more -${window}
        else
	    # emulate more -WINDOW
	    # See: https://stackoverflow.com/questions/36442572\
	    # /how-to-make-return-trap-in-bash-preserve-the-return-code
	    # XXX: stty --save/-g is NOT preserving rows?!
            # local saved=$(stty --file=/dev/tty --save)
	    # trap "stty --file=/dev/tty ${saved}; trap - RETURN" RETURN
	    local errmsg="${BASH_SOURCE}: LINES not set!}"
	    # XXX: Also trap RETURN is NOT firing under msys?!
	    # trap "stty --file=/dev/tty rows ${LINES:?${errmsg}};\
	    # trap - RETURN" RETURN
	    stty --file=/dev/tty rows ${window}
	    less -XF
	    stty --file=/dev/tty rows ${LINES:?${errmsg}}
        fi
}
