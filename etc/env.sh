# Miscellanous environment variables
#
# SEE ALSO
# * https://unix.stackexchange.com/questions/76354/\
    # who-sets-user-and-username-environment-variables/76356
# * id(1)
# * logname(1)
# * path.sh
# * whoami(1)

# Export these near universal variables as needed.
: ${LOGNAME:=$(logname)}	# Expected by SystemV programs
: ${USER:=$(id -un)}		# Expected by BSD programs
export LOGNAME USER

# Pass COLUMNS thru to commands that want to know the terminal width, e.g:
# https://github.com/evilkim/bashisms/git_sdiff
# N.B: As needed, resizing the terminal may initialize COLUMNS.
export COLUMNS
