#!/usr/bin/env bats

# @file tests/install/ubuntu/setup-wsl2.bats
# @brief Tests for the WSL2 detection wiring in setup.sh.
#
# setup.sh sources the centralized helper install/common/wsl2.sh (providing
# is_wsl2) and initialize_os_linux() calls is_wsl2() to detect WSL2 at setup
# time without changing native Linux behavior.
#
# NOTE: setup.sh defines its own `run` function, which clobbers Bats' `run`
# helper. These tests therefore invoke the functions directly and capture
# output/exit status explicitly instead of using Bats' `run`.

bats_require_minimum_version 1.5.0

readonly SETUP_PATH="./setup.sh"

function setup() {
    # setup.sh unconditionally runs `main "$@"` at the end of the file, which
    # would execute the real setup (sudo, chezmoi download, etc.). To test the
    # wiring in isolation we stub main() to a no-op and mark it readonly so
    # setup.sh cannot redefine it. setup.sh also sets `set -e`; the readonly
    # redefinition error would otherwise abort the source, so we re-apply
    # `set +e` on ERR for the duration of the source.
    main() { :; }
    readonly -f main 2> /dev/null
    trap 'set +e' ERR
    source "${SETUP_PATH}" 2> /dev/null
    trap - ERR
}

@test "[ubuntu] setup.sh sources install/common/wsl2.sh" {
    # The source statement for the centralized helper must be present.
    grep -q 'install/common/wsl2.sh' "${SETUP_PATH}"

    # is_wsl2 must be available after sourcing setup.sh.
    [ "$(type -t is_wsl2)" = "function" ]
}

@test "[ubuntu] initialize_os_linux detects WSL2 and echoes a message" {
    # Mock is_wsl2 to report a WSL2 environment.
    is_wsl2() { return 0; }

    output="$(initialize_os_linux)"
    status=$?
    [ "${status}" -eq 0 ]
    [ "${output}" = "Detected WSL2 environment." ]
}

@test "[ubuntu] initialize_os_linux preserves native Linux behavior when not WSL2" {
    # Mock is_wsl2 to report a native (non-WSL2) Linux environment.
    is_wsl2() { return 1; }

    output="$(initialize_os_linux)"
    status=$?
    [ "${status}" -eq 0 ]
    [ -z "${output}" ]
}
