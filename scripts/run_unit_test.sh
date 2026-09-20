#!/usr/bin/env bash

# @file scripts/run_unit_test.sh
# @brief Run the repository's shell unit tests.
# @description
#   Dispatches the common Bats suite and the OS-specific Bats suite selected by
#   the explicit `TARGET_OS` environment variable.

set -Eeo pipefail

#
# @description Run the install tests shared across all targets.
#
function run_common_test() {
    bats -r "tests/install/common/"
}

#
# @description Run the OS-specific Bats suite for the active target.
#
function run_os_specific_test() {
    case "${TARGET_OS:-}" in
    macos | darwin)
        bats -r "tests/install/macos/"
        ;;
    linux | ubuntu)
        bats -r "tests/install/ubuntu/"
        ;;
    *)
        echo "${TARGET_OS:-<unset>} are not supported" >&2
        exit 1
        ;;
    esac
}

#
# @description Run the full unit test flow.
#
function main() {
    run_common_test
    run_os_specific_test
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
