#!/usr/bin/env bash

# @file install/common/brew.sh
# @brief Shared Homebrew package installation helpers.
# @description
#   Provides the common logic for installing Homebrew packages on any platform
#   that runs Homebrew (macOS and Linux). Platform-specific package lists live
#   in the per-OS `dependencies.sh` and `misc.sh` scripts, which source this
#   file and call `install_brew_packages` with their own package list.

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

#
# @description Check whether a Homebrew package is already installed.
# @arg $1 string Homebrew package name.
#
function is_brew_package_installed() {
    local package="$1"

    # Distinguish a genuinely missing package (exit 1) from a broken brew
    # (exit 2). If brew itself is unavailable, that is a hard environment
    # failure, not "package not installed" — surface it instead of silently
    # treating it as a missing package.
    if ! command -v brew &> /dev/null; then
        echo "error: Homebrew (brew) is not installed or not on PATH" >&2
        return 2
    fi

    brew list "${package}" &> /dev/null
}

#
# @description Install every missing package from the given list.
# @arg $@ string Homebrew package names.
#
function install_brew_packages() {
    local missing_packages=()
    local package

    for package in "$@"; do
        if ! is_brew_package_installed "${package}"; then
            missing_packages+=("${package}")
        fi
    done

    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        brew install --force "${missing_packages[@]}"
    fi
}
