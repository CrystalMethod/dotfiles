#!/usr/bin/env bats

# @file tests/install/ubuntu/wsl2.bats
# @brief Unit tests for install/common/wsl2.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/common/wsl2.sh"

function setup() {
    export UNAME_RELEASE_FILE="${BATS_TEST_TMPDIR}/uname_release.txt"
    : > "${UNAME_RELEASE_FILE}"

    # Stub `uname` so that `uname -r` returns the configured release while the
    # real `uname` remains reachable for any other invocation.
    cat > "${BATS_TEST_TMPDIR}/uname" << 'UNAME'
#!/usr/bin/env bash
if [ "${1:-}" = "-r" ]; then
    cat "${UNAME_RELEASE_FILE}"
    exit 0
fi
exit 1
UNAME
    chmod +x "${BATS_TEST_TMPDIR}/uname"

    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    source "${SCRIPT_PATH}"
}

function mock_uname_release() {
    printf '%s\n' "$1" > "${UNAME_RELEASE_FILE}"
}

@test "[ubuntu] is_wsl2 returns 0 when kernel release contains microsoft" {
    mock_uname_release "5.15.153.1-microsoft-standard-WSL2"

    run is_wsl2
    [ "${status}" -eq 0 ]
}

@test "[ubuntu] is_wsl2 returns non-zero when kernel release lacks microsoft" {
    mock_uname_release "6.8.0-45-generic"

    run is_wsl2
    [ "${status}" -ne 0 ]
}

@test "[ubuntu] is_wsl2 is case-insensitive (Microsoft matches)" {
    mock_uname_release "5.15.153.1-Microsoft-standard-WSL2"

    run is_wsl2
    [ "${status}" -eq 0 ]
}

@test "[ubuntu] sourcing wsl2.sh has no side effects" {
    run bash -c 'source ./install/common/wsl2.sh'
    [ "${status}" -eq 0 ]
    [ -z "${output}" ]
}
