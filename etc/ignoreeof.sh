if [[ "${SHLVL}" == 1 ]]; then
    set -o ignoreeof		# prevent accidental ^D logout ...
    IGNOREEOF=2			# ... but 3rd time's the charm
fi
