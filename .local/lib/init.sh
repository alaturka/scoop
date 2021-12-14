# shellcheck shell=bash

set -Eeuo pipefail; shopt -s nullglob; unset CDPATH; IFS=$' \t\n'

export LC_ALL=C.UTF-8 LANG=C.UTF-8

abort() {
	echo -e "\e[1m\e[38;5;9m✗\e[0m \e[1m$*\e[0m" >&2
	exit 1
}

doing() {
	echo -e "\e[1m\e[38;5;14m>\e[0m \e[1m$*\e[0m" >&2
}

warn() {
	echo -e "\e[1m\e[38;5;11m!\e[0m $*\e[0m" >&2
}

init() {
	local dir

	if [[ -d ${LOCAL_DIR:-} ]]; then
		dir="$LOCAL_DIR"
	else
		dir="${BASH_SOURCE[0]%/*}"/../..
	fi

	cd "$dir" || abort "Failed to chdir: $dir"

	# Only chance for customization
	[[ ! -f .local/etc/environment ]] || builtin source .local/etc/environment

	[[ ! -d .local/var/bin ]] || export PATH=$PWD/.local/var/bin:$PATH

	# Needs for aggressively restricted Github actions, i.e. education/autograding
	[[ -n "${HOME:-}" ]] || export HOME=$PWD/.local/tmp
}

init
