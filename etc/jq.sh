# HELP - jq is the "Swiss Army Knife for JSON"

function jqpp {
    # Pretty print JSON
    jq -C "${@}" | less -R
}
