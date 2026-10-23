#!/usr/bin/env bash

# @file install/common/fonts.sh
# @brief Shared helper for refreshing the fontconfig cache for bundled fonts.
# @description
#   The repo bundles paid fonts (e.g. MonoLisa) as age-encrypted
#   `encrypted_*.ttf.age` sources. Each platform stores its own encrypted copy
#   under a path that maps directly to the platform font directory:
#   - macOS:  `home/Library/Fonts/`  -> `~/Library/Fonts/`
#   - Linux:  `home/private_dot_local/share/fonts/` -> `~/.local/share/fonts/`
#
#   chezmoi decrypts these at apply time, so no copying is required. On
#   Linux/WSL2, the only extra step is refreshing the fontconfig cache, which
#   this file provides. macOS CoreText picks up fonts from `~/Library/Fonts`
#   automatically.

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

#
# @description Print the font family directory under the home directory.
# @arg $1 string Font family directory relative to the font root.
# @stdout Absolute path to the font family directory.
#
function font_family_dir() {
    local family="$1"
    printf '%s/%s' "${HOME}" "${family}"
}

#
# @description Refresh the fontconfig cache (Linux/WSL2).
# @description Runs `fc-cache -f` for the given family directory when available.
# @arg $1 string Font family directory (absolute).
#
function refresh_font_cache() {
    local dir="$1"
    if command -v fc-cache > /dev/null 2>&1; then
        fc-cache -f "${dir}" > /dev/null 2>&1 || true
    fi
}
