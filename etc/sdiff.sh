function sdiff {
    # auto-width
    command sdiff --width=${COLUMNS:?${BASH_SOURCE}: COLUMNS not set!?} "${@}"
}

return
echo >&@ "${BASH_SOURCE}: You cannot get here from there!?"

# Ensure COLUMNS is set?
if tty -s; then
    : ${COLUMNS:=$(stty --file=/dev/tty -a |
		       grep -o -P 'columns \d+' | grep -o -P '\d+')}
else
    : ${COLUMNS:=130}		# sdiff(1) default width
fi
