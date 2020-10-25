set -o noclobber		# use >! to replace existing file

# ask nicely before clobbering
# (override with e.g. "\cp" or "/bin/cp" or "command cp")

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
