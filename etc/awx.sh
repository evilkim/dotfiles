# HELP - Encapsulate authentication and common queries for Ansible Tower (AWX)
# SEE ALSO
# * jq			-- Cygwin or https://stedolan.github.io/jq/download/
# * txt2table		-- https://github.com/evilkim/bashisms.git
# * ~/etc/local.d/awx.sh -- Local config (if any)

function _awx { (${_awx_xtrace}; awx ${_awx_debug} --conf.insecure "${@}"); }

function awx-job_templates { (_awx job_templates list "${@}") | _awx_tsv; }

function awx-organizations { _awx organizations list "${@}" | _awx_tsv; }

function awx-projects { _awx projects list "${@}" | _awx_tsv; }

function awx-users {
    _awx users list "${@}" |
	if ${_awx_raw:-false}; then
	    cat
	else
	    jq -r '["ID","USERNAME","EMAIL"],
(.results[] | .username |= ascii_upcase |
[(.id, .username, .email)]) | @tsv' |
		txt2table
	fi
}

function awx-jobs {
    _awx jobs list --all "${@}" |
	if ${_awx_raw:-false}; then
	    cat
	else
	    jq -r '["ID","STATUS","FINISHED","NAME","PLAYBOOK","DESCRIPTION","USERNAME"],
(.results[] |
  .finished |= sub("[.].*";"") |
  .finished |= sub("T";" ") |
  .finished |= sub(":[^:]*$";" ") |
[(.id, .status, .finished, .name, .playbook, .description, .summary_fields.created_by.username)]) | @tsv' |
		txt2table |
		tsv-sort -r -k +3 |
		expand |
		cut -c1-${COLUMNS:-132}
	fi
}

function awx-teams {
    _awx teams list "${@}" |
	if ${_awx_raw:-false}; then
	    cat
	else
	    jq -r '["ID","NAME","DESCRIPTION"],
(.results[] |
[(.id, .name, .description)]) | @tsv' |
		txt2table
	fi
}

# These would be aliases, but cannot use aliases inside functions
function awx-job-templates { awx-job_templates "${@}"; }
function awx-orgs { awx-organizations "${@}"; }
function awx-templates { awx-job_templates "${@}"; }

function _awx_tsv {
    # Prepare table for certain objects w/ common row headers
    if ${_awx_raw:-false}; then
	cat
    else
	jq -r '["ID","NAME","DESCRIPTION","CREATED","MODIFIED"],
(.results[] |
[(.id,.name,.description?,.created?,.modified?)]) | @tsv' |
	    txt2table
    fi
}

function awx-xtrace {
    # Toggle _awx_xtrace for awx* functions
    if [[ "${#_awx_xtrace}" -gt 1 ]]; then
	_awx_xtrace=":"
	echo >&2 "${FUNCNAME}: info: Disabled xtrace"
    else
	_awx_xtrace="set -o xtrace"
	echo >&2 "${FUNCNAME}: info: Enabled xtrace"
    fi
}

function awx-debug {
    # Toggle _awx_debug for awx* functions
    if [[ -n "${_awx_debug}" ]]; then
	_awx_debug=""
	echo >&2 "${FUNCNAME}: info: Disabled verbose option"
    else
	_awx_debug="-v"
	echo >&2 "${FUNCNAME}: info: Enabled verbose option"
    fi
}

function _awx-raw {
    # HELP - Disable jq post-processing for command (e.g. for --help)
    (${_awx_xtrace}; _awx_raw=true "${@}")
}

function awx-help {
    # HELP - Show help for given {resource}
    # Usage: awx-help {resource}
    # Disables jq post-processing for awx-* commands defined herein.
    # N.B: Inexplicably, all `awx {resource} --help` commands require you
    # first login to TOWER_HOST?!
    _awx-raw "${@}" --help
}

# Maintain credentials for multiple Tower instances for life of this shell
declare -A -g awx_tokens
# EXAMPLE: awx_tokens+=([TOWER_HOST]=TOWER_TOKEN)

function awx-set-host {
    # HELP - Set TOWER_HOST from NICKNAME or URL
    # NICKNAME can be presented in any case, it is forced to uppercase
    local result="${1:-${TOWER_HOST:-${awx_default_host:-}}}"
    if [[ -n "${awx_hosts[${result^^}]}" ]]; then
       result="${awx_hosts[${result^^}]}" # map NICKNAME to URL
    fi
    export TOWER_HOST="${result}"
    # DEBUG: declare -p TOWER_HOST
    if [[ -z "${TOWER_HOST}" ]]; then
	echo >&2 "${FUNCNAME[1]}: error: Missing TOWER_HOST"
	return 2
    fi
}

function awx-login {
    # HELP - Login to default or given Tower instance
    # SEE ALSO: https://github.com/ansible/awx/pull/9491
    local usage="${FUNCNAME} [TOWER_HOST]"
    declare -A -g awx_tokens
    awx-set-host "${*}" || return ${?}
    local token="${awx_tokens[${TOWER_HOST}]}"
    if [[ -z "${token}" ]]; then
	local prompt="Password for ${USER,,}@${TOWER_HOST/https:\/\/}"
	local password; read -s -p "${prompt}: " password; echo >&2
	local response=$(
	    export TOWER_PASSWORD="${password}" # evaporates with subshell
	    _awx login --conf.username="${USER,,}")
	token=$(
	    echo "${response}" | jq -r .token || {
		echo >&2 "${FUNCNAME}: error: ${TOWER_HOST}:"\
			 "No token in response"
		echo >&2 "${response}"
	    })
	awx_tokens["${TOWER_HOST}"]="${token}" # cache the token
    fi
    export TOWER_OAUTH_TOKEN="${token}"
    # DEBUG: declare -p awx_tokens
}

function awx-logout {
    # HELP - Logout from current or given Tower instance
    local usage="${FUNCNAME} [TOWER_HOST]"
    declare -A -g awx_tokens
    awx-set-host "${*}" || return ${?}
    unset TOWER_OAUTH_TOKEN
    unset awx_tokens["${TOWER_HOST}"] # clear the cache
    # DEBUG: declare -p awx_tokens
}

function awx-whois {
    # HELP - Lookup user email by username
    local username="${1:-${USER}}"
    _awx-raw awx-users --username "${username,,}" | # lowercase
	jq -r '.results[].email'
}

# TODO: Store tokens in AWXKIT_CREDENTIAL_FILE (one per TOWER_HOST)?
# See Also:
# * https://docs.ansible.com/ansible-tower/latest/html/towercli/authentication.html
# * [making the cli use AWXKIT_CREDENTIAL_FILE](https://github.com/ansible/awx/pull/9491)
# * https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-config
#
# $ export AWXKIT_CREDENTIAL_FILE=~/.awx.cfg
# $ awx-login ${TOWER_HOST}
# $ awx config > "${TOWER_CONFIG_FILE}"
