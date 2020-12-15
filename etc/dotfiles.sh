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
alias dotfiles="git --git-dir='${dotfiles}' --work-tree='${HOME}'"
alias dotgit=dotfiles  # Errant `git` command can be re-entered as `dot!!`

function dotfiles-untracked {
    # Report any untracked DotFiles
    local result="/tmp/${FUNCNAME}.txt"
    # DotFiles are relative to ${HOME}
    # Cygwin git respects whereas Git for Windows ignores core.excludedFiles, so make it explicit
    (builtin cd ~ && dotfiles ls-files --other --exclude-standard --exclude-from "$(dotfiles config --get core.excludesFile || /dev/null)") |
        tee "${result}" |
        if grep .; then
            echo >&2 "${BASH_SOURCE}: Untracked DotFiles in ${result}"
        else
            echo >&2 "${BASH_SOURCE}: No untracked DotFiles"
        fi
}

function dotfiles-modified {
    # Report any modified DotFiles
    local result="/tmp/${FUNCNAME}.txt"
    # DotFiles are relative to ${HOME}
    (builtin cd ~ && dotfiles ls-files --modified) |
        tee "${result}" |
        if grep .; then
            echo >&2 "${BASH_SOURCE}: Modified DotFiles in ${result}"
        else
            echo >&2 "${BASH_SOURCE}: No modified DotFiles"
        fi
}

dotfiles-untracked > /dev/null
dotfiles-modified > /dev/null
