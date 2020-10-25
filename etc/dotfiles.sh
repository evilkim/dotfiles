# Maintain "dotfiles" in a bare Git repository
#
# EXAMPLES
# * dotfiles status
# * dotfiles ls-files --others --exclude-standard
# * dotfiles add remote origin REMOTE_URL
# * dotfiles push
# * git clone --separate-git-dir=${dotfiles} REMOTE_URL ${HOME}
#
# SEE ALSO
# * ${dotfiles}/info/exclude
# * https://www.atlassian.com/git/tutorials/dotfiles
# * ~/.gitignore

if [[ ${OS} == Windows_NT ]]; then
    # On Windows, keep DotFiles Git repository on OneDrive if present
    : ${dotfiles:="${OneDrive:-${HOME}}/src/.dotfiles.git"}
else
    : ${dotfiles:="${HOME}/src/.dotfiles.git"}
fi

dotfiles_home="${HOME}"
case "${OSTYPE}" in
    cygwin)
	# Git Bash provided /cmd/git.exe doesn't understand /c prefix
	# Native Cygwin git would understand either syntax, but no need
	if [[ "$(which git)" == "/c/Program Files/Git/cmd/git" ]]; then
	    dotfiles=$(cygpath -ms "${dotfiles}")
	    dotfiles_home=$(cygpath -ms "${dotfiles_home}")
	fi
	;;
esac

alias dotfiles='git --git-dir="${dotfiles}" --work-tree="${dotfiles_home}"'
alias dotgit=dotfiles		# So `git ...` can be re-entered as `dot!!`
