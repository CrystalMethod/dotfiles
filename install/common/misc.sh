#!/usr/bin/env bash

# @file install/common/misc.sh
# @brief Install optional Homebrew packages.
# @description
#   Installs non-essential Homebrew packages that are not prerequisites for
#   the dotfiles setup. Essential packages live in the platform dependencies.sh.

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

# shellcheck source-path=SCRIPTDIR
# shellcheck source=brew.sh
if ! declare -F install_brew_packages > /dev/null 2>&1; then
    source "$(dirname "${BASH_SOURCE[0]}")/brew.sh"
fi

BREW_PACKAGES=(
    rbw
)

#
# @description Install the optional Homebrew packages.
#
function main() {
    install_brew_packages "${BREW_PACKAGES[@]}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
