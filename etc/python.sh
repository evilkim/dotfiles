case "${OSTYPE}" in
    msys)
	# Git Bash can borrow python from Cygwin
	alias python2='/c/Cygwin/bin/python2.7.exe'
	alias python3='/c/Cygwin/bin/python3.6m.exe'
	alias python=python3
	;;
esac
