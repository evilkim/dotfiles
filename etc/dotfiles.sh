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
# * https://dotfiles.github.io/inspiration/
# * https://www.atlassian.com/git/tutorials/dotfiles
# * ~/.gitignore

if [[ ${OS} == Windows_NT ]]; then
    # On Windows, keep dotfiles repository on OneDrive if present
    : ${dotfiles:="${OneDrive:-${HOME}}/src/.dotfiles.git"}

    # Git Bash provided /cmd/git.exe doesn't understand /c prefix
    # Native Cygwin git would understand either syntax, but simpler
    # to just define for both in "safe" manner
    dotfiles=$(cygpath -ms "${dotfiles}")
    dotfiles_home=$(cygpath -ms "${HOME}")
else
    : ${dotfiles:="${HOME}/src/.dotfiles.git"}
    dotfiles_home="${HOME}"
fi

alias dotfiles="git --git-dir='${dotfiles}' --work-tree='${dotfiles_home}'"
alias dotgit=dotfiles  # Errant `git` command can be re-entered as `dot!!`

unset dotfiles_home		# discard temporary var
