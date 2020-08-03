#!/bin/bash

set -e

cd "$(realpath "$(dirname "$0")/../.git")"

install_hook() {
	hook="$1"
	hook_file="./hooks/$hook"
	rm -f "$hook_file"
	ln -s "../../git-hooks/$hook" "$hook_file"
	chmod +x "$hook_file"
	echo "Installed: $hook_file"
}

install_hook pre-commit
