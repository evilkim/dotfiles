# Maintain "dotfiles" in a bare Git repository
#
# EXAMPLES
# 1. Day-to-day usage:
#   * dotfiles status
#   * dotfiles ls-files --exclude-standard --others
#   * dotfiles add remote origin REMOTE_URL
#   * dotfiles push
# 2. Configure new server:
#   * dotfiles=/path/to/dotfiles/repo # align with definition below
# 2a. Using a bare repository:
#   * git clone --bare REMOTE_URL ${dotfiles}
#   * git --git-dir=${dotfiles} --work-tree=${HOME} checkout [-f] # or:
#   * git --git-dir=${dotfiles} checkout-index -a [-f] ${HOME}/
# 2b. TESTME: Using a separate repository (creates a .git "symlink"):
#   * git clone --separate-git-dir=${dotfiles} REMOTE_URL ${HOME}
#   * mv ${HOME}/.git ${HOME}/.dotfiles.git
#   * git --git-dir=${HOME}/.dotfiles.git config --add core.worktree ${HOME}
#   * alias dotfiles='git --git-dir=${HOME}/.dotfiles.git'
#
# SEE ALSO
# * ${dotfiles}/info/exclude # maintained by hand and is *not* committed!
# * dotfiles config status.showUntrackedFiles no # in lieu of the above
# * https://dotfiles.github.io/inspiration/
# * https://www.atlassian.com/git/tutorials/dotfiles
# * ~/.gitignore

: ${dotfiles:="${HOME}/.dotfiles.git"}

function dotfiles {
    # See ~/.dotfiles.gitignore for why this G4W workaround is needed
    local g4w=(-c core.excludesfile="${HOME}/.dotfiles.gitignore")
    [[ "${OSTYPE}" == msys ]] || g4w=()
    # DotFiles are relative to ${HOME}
    git -C "${HOME}"\
	--git-dir="${dotfiles}"\
	--work-tree="${HOME}"\
	"${g4w[@]}" "${@}"
}

alias dotgit=dotfiles  # Errant `git` command can be re-entered as `dot!!`

# Show status upon login:
(dotfiles status -sb)
