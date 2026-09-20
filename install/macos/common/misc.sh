#!/usr/bin/env bash

# @file install/macos/common/misc.sh
# @brief Install optional Homebrew packages for macOS.
# @description
#   Installs non-essential Homebrew packages that are not prerequisites for
#   the dotfiles setup. Essential packages live in
#   `install/macos/common/dependencies.sh`.

# shellcheck source-path=SCRIPTDIR
# shellcheck source=../../common/misc.sh
source "$(dirname "${BASH_SOURCE[0]}")/../../common/misc.sh"
