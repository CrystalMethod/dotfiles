#!/usr/bin/env bash

# @file install/ubuntu/common/misc.sh
# @brief Install optional Homebrew packages for Ubuntu.
# @description
#   Installs non-essential Homebrew packages that are not prerequisites for
#   the dotfiles setup on Ubuntu (including WSL2). Essential packages live in
#   `install/ubuntu/common/dependencies.sh`.

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

# shellcheck source-path=SCRIPTDIR
# shellcheck source=../../common/brew.sh
if ! declare -F install_brew_packages >/dev/null 2>&1; then
    source "$(dirname "${BASH_SOURCE[0]}")/../../common/brew.sh"
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
