function git {
    # Suppress the abominable banner from GitLab-CI server except on error
    local stderr=$(mktemp); trap "rm -f ${stderr}; trap - RETURN" RETURN
    command git "${@}" 2>>${stderr} ||
	{ local rc=${?}; cat >&2 ${stderr}; return ${rc}; }
}

function git_suppress_banner {
    # Suppress the crud between 1st and 2nd lines of all *** inclusive
    # This still passes thru the extraneous (yet tolerable) From {GIT_URL}
    perl -lne '
if (/^[*]+$/) {
    unless ($banner_seen) { $banner_seen++ if $in_banner++; next; }
}
# handle also the case where no banner is present
undef $in_banner if $banner_seen;
print unless $in_banner;
' "${@}"
}

function git-prepull {
    # https://stackoverflow.com/questions/180272\
	# /how-to-preview-git-pull-without-doing-fetch
    git fetch "${@}"
    git log HEAD..@{upstream}
}
