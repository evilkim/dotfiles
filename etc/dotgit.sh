# Maintain "DotFiles" in a bare Git repository
#
# EXAMPLES
# * dotgit status
# * dotgit ls-files --others --exclude-standard
# * dotgit add remote origin REMOTE_URL
# * dotgit push
# * git clone --separate-git-dir=${dotgit} REMOTE_URL ${HOME}
#
# SEE ALSO
# * ${dotgit}/info/exclude
# * https://www.atlassian.com/git/tutorials/dotfiles
# * ~/.gitignore

if [[ ${OS} == Windows_NT ]]; then
    # On Windows, keep DotFiles Git repository on OneDrive if present
    : ${dotgit:="${OneDrive:-${HOME}}/src/.dotfiles.git"}
else
    : ${dotgit:="${HOME}/src/.dotfiles.git"}
fi

dotgit_home="${HOME}"
case "${OSTYPE}" in
    cygwin)
	# Git Bash provided /cmd/git.exe doesn't understand /c prefix
	# Native Cygwin git would understand either syntax, but no need
	if [[ "$(which git)" == "/c/Program Files/Git/cmd/git" ]]; then
	    dotgit=$(cygpath -ms "${dotgit}")
	    dotgit_home=$(cygpath -ms "${dotgit_home}")
	fi
	;;
esac

alias dotgit='git --git-dir="${dotgit}" --work-tree="${dotgit_home}"'
