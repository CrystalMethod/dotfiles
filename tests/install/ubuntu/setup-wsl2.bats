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
    MODE=user
    initialize_homebrew_user() { :; }

    output="$(initialize_os_linux)"
    status=$?
    [ "${status}" -eq 0 ]
    [ "${output}" = "Detected WSL2 environment." ]
}

@test "[ubuntu] initialize_os_linux preserves native Linux behavior when not WSL2" {
    # Mock is_wsl2 to report a native (non-WSL2) Linux environment.
    is_wsl2() { return 1; }
    MODE=user
    initialize_homebrew_user() { :; }

    output="$(initialize_os_linux)"
    status=$?
    [ "${status}" -eq 0 ]
    [ -z "${output}" ]
}

@test "[ubuntu] privileged Linux setup installs prerequisites and Homebrew" {
    is_wsl2() { return 1; }
    is_linux_homebrew_exists() { return 1; }
    run() {
        printf '[run]'
        printf ' %q' "$@"
        printf '\n'
    }
    logAndExec() { printf '[exec] %s\n' "$1"; }
    run_brew_shellenv() { printf '[shellenv] %s\n' "$1"; }

    MODE=privileged
    DRY_RUN=true
    output="$(initialize_os_linux)"

    [[ "${output}" == *"[run] sudo apt-get update"* ]]
    [[ "${output}" == *"[run] sudo apt-get install -y build-essential procps curl file git"* ]]
    [[ "${output}" == *'installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && NONINTERACTIVE=1 /bin/bash -c "$installer"'* ]]
    [[ "${output}" == *"[shellenv] /home/linuxbrew/.linuxbrew/bin/brew"* ]]
}

@test "[ubuntu] privileged Linux setup skips installation when Homebrew exists" {
    is_wsl2() { return 1; }
    is_linux_homebrew_exists() { return 0; }
    run() {
        printf '[run]'
        printf ' %q' "$@"
        printf '\n'
    }
    logAndExec() { printf '[exec] %s\n' "$1"; }
    run_brew_shellenv() { printf '[shellenv] %s\n' "$1"; }
    MODE=privileged
    output="$(initialize_os_linux)"

    [[ "${output}" != *"apt-get"* ]]
    [[ "${output}" != *"Homebrew/install"* ]]
    [[ "${output}" == *"[shellenv] /home/linuxbrew/.linuxbrew/bin/brew"* ]]
}

@test "[ubuntu] user Linux setup uses user-space Homebrew without sudo" {
    is_wsl2() { return 1; }
    initialize_homebrew_user() { printf '[user-homebrew]\n'; }
    run() {
        printf '[run]'
        printf ' %q' "$@"
        printf '\n'
    }
    logAndExec() { printf '[exec] %s\n' "$1"; }
    run_brew_shellenv() { printf '[shellenv] %s\n' "$1"; }

    MODE=user
    output="$(initialize_os_linux)"

    [[ "${output}" == *"[user-homebrew]"* ]]
    [[ "${output}" != *"sudo"* ]]
    [[ "${output}" != *"/home/linuxbrew/.linuxbrew/bin/brew"* ]]
}

@test "[ubuntu] Homebrew installer download failure aborts before Bash" {
    curl() { return 22; }
    DRY_RUN=false

    if logAndExec 'installer="$(curl -fsSL https://example.invalid/install.sh)" && /bin/bash -c "$installer"'; then
        status=0
    else
        status=$?
    fi

    [ "${status}" -ne 0 ]
}

@test "[ubuntu] Homebrew installer dry-run skips download" {
    curl() {
        printf 'curl-called\n'
        return 22
    }
    DRY_RUN=true

    output="$(logAndExec 'installer="$(curl -fsSL https://example.invalid/install.sh)" && /bin/bash -c "$installer"')"

    [[ "${output}" == *"[dry-run]"* ]]
    [[ "${output}" != *"curl-called"* ]]
}
