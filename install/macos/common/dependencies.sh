#!/usr/bin/env bash

# @file install/macos/common/dependencies.sh
# @brief Install essential Homebrew packages for macOS.
# @description
#   Installs the core command-line packages required by the dotfiles.
#   Optional utilities and GUI applications live in
#   `install/macos/common/misc.sh`.

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

# shellcheck source-path=SCRIPTDIR
# shellcheck source=../../common/brew.sh
if ! declare -F install_brew_dependencies >/dev/null 2>&1; then
    source "$(dirname "${BASH_SOURCE[0]}")/../../common/brew.sh"
fi

BREW_PACKAGES=(
    cmake
    git
    gpg
    pinentry-mac
    vim
    zsh
)

#
# @description Install the required Homebrew dependencies.
#
function main() {
    install_brew_dependencies "${BREW_PACKAGES[@]}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
