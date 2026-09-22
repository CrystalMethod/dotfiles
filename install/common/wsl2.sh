#!/usr/bin/env bash

# @file install/common/wsl2.sh
# @brief Centralized WSL2 detection helper.
# @description
#   Provides a single source of truth for detecting whether the current
#   environment is WSL2. Both the setup scripts and the test suite source this
#   file and call `is_wsl2`. Sourcing this file has no side effects.

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

#
# @description Check whether the current environment is WSL2.
# @stdout Nothing.
# @exitcode 0 If the kernel release contains "microsoft" (case-insensitive).
# @exitcode 1 Otherwise.
#
function is_wsl2() {
    local kernel_release
    kernel_release="$(uname -r)"

    # WSL2 kernels report a release string containing "microsoft" (e.g.
    # "5.15.153.1-microsoft-standard-WSL2"). Match case-insensitively.
    [[ "${kernel_release,,}" == *microsoft* ]]
}
