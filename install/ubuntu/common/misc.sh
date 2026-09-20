#!/usr/bin/env bash

# @file install/ubuntu/common/misc.sh
# @brief Install optional Homebrew packages for Ubuntu.
# @description
#   Installs non-essential Homebrew packages that are not prerequisites for
#   the dotfiles setup on Ubuntu (including WSL2). Essential packages live in
#   `install/ubuntu/common/dependencies.sh`.

# shellcheck source-path=SCRIPTDIR
# shellcheck source=../../common/misc.sh
source "$(dirname "${BASH_SOURCE[0]}")/../../common/misc.sh"
