if netstat -an|grep -q -e ' 127.0.0.1:3128 .* LISTEN'; then
    echo >&2 "${BASH_SOURCE}: cntlm is already running"
elif [[ -x /usr/sbin/cntlm ]] && [[ -f /etc/cntlm.conf ]]; then
    /usr/sbin/cntlm -c /etc/cntlm.conf || echo >&2 "${BASH_SOURCE}: cntlm failed to start"
else
    echo >&2 "${BASH_SOURCE}: cntlm is not running"
fi

export no_proxy='localhost, 127.0.0.*, 10.*, 192.168.*'
export http_proxy="localhost:3128"
export https_proxy="${http_proxy}"

# ## Pre-requisites:
#
# ### Set the Proxy
#
# * Find the proxy AutoConfigURL
#
# $ strings /proc/registry*/HKEY_CURRENT_USER/Software/Microsoft/Windows/CurrentVersion/Internet?Settings/AutoConfigURL
#
# * Download the URL discovered above and discover the default proxy
#
# $ curl -O {AutoConfigURL} | grep return | tail -1
#
# * Set the discovered Proxy value in /etc/cntlm.conf
#
# * Create token from current username/password
#
# $ /usr/sbin/cntlm.exe -H -c /etc/cntlm.conf
# Password:
# PassNTLMv2 {TOKEN} # Only for user %USERNAME%, domain %USERDNSDOMAIN%
#
# * Add token to /etc/cntlm.conf
#
# REFERENCES
#
# * https://superuser.com/questions/346372/\
#   how-do-i-know-what-proxy-server-im-using
