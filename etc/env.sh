# Miscellanous variables

TIMEFORMAT="time: %0lR"		# unset to revert to default

# Set these near universal variables as needed.
: ${USER:=$(id -un)}		# Expected by BSD programs
: ${LOGNAME:=$(logname)}	# Expected by SystemV programs

# SEE ALSO
# * https://unix.stackexchange.com/questions/76354/\
#   who-sets-user-and-username-environment-variables/76356
# * id(1)
# * logname(1)
# * whoami(1)
