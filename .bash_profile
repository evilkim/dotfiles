echo >&2 "${BASH_SOURCE}: ENTER" # Uncomment to help isolate any errors
#-----------------------------------------------------------------------------#

if [[ -f /etc/skel/.bash_profile ]]; then
    # Cygwin and many *nix, will automatically chain to ~/.bashrc
    echo >&2 "/etc/skel/.bash_profile: ENTER"
    source /etc/skel/.bash_profile
    #echo >&2 "/etc/skel/.bash_profile: LEAVE"
elif [[ -f "${HOME}/.bashrc" ]]; then
    source "${HOME}/.bashrc"
fi

#-----------------------------------------------------------------------------#
#echo >&2 "${BASH_SOURCE}: LEAVE"
