#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/buildcheck.sh"
. "$DIR/minimalcheck.sh"
. "$DIR/base.sh"
. "$DIR/ansi"

if [[ -d "$HOME/.ssh" ]]; then
	ansi --green "SSH file chmod..."

	chmod 755 "$HOME"/.ssh
	[[ -f "$HOME/.ssh/id_rsa" ]] && chmod 600 "$HOME"/.ssh/id_rsa
	[[ -f "$HOME/.ssh/id_rsa.pub" ]] && chmod 600 "$HOME"/.ssh/id_rsa.pub
fi
