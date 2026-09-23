#!/usr/bin/env bash

# @file install/macos/common/misc.sh
# @brief Install optional Homebrew packages for macOS.
# @description
#   Installs non-essential Homebrew packages that are not prerequisites for
#   the dotfiles setup. Essential packages live in the platform dependencies.sh.
#   This macOS-specific list holds packages that must not be installed on other
#   platforms (e.g. bash, which is apt-managed on Linux).

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

# shellcheck source-path=SCRIPTDIR
# shellcheck source=../../common/brew.sh
if ! declare -F install_brew_packages > /dev/null 2>&1; then
    source "$(dirname "${BASH_SOURCE[0]}")/../../common/brew.sh"
fi

BREW_PACKAGES=(
    bash
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
