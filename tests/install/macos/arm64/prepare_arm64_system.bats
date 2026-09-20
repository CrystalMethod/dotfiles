#!/usr/bin/env bats

# @file tests/install/macos/arm64/prepare_arm64_system.bats
# @brief Unit tests for install/macos/arm64/prepare_arm64_system.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/macos/arm64/prepare_arm64_system.sh"

function setup() {
    export SOFTWAREUPDATE_CALLS_PATH="${BATS_TEST_TMPDIR}/softwareupdate_calls.txt"
    export ROSETTA_PATH="${BATS_TEST_TMPDIR}/rosetta"

    cat > "${BATS_TEST_TMPDIR}/softwareupdate" << 'SOFTWAREUPDATE'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${SOFTWAREUPDATE_CALLS_PATH}"
SOFTWAREUPDATE
    chmod +x "${BATS_TEST_TMPDIR}/softwareupdate"

    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    source "${SCRIPT_PATH}"
}

@test "[macos] install_rosetta installs Rosetta when it is missing" {
    run install_rosetta
    [ "${status}" -eq 0 ]
    [ "$(< "${SOFTWAREUPDATE_CALLS_PATH}")" = "--install-rosetta --agree-to-license" ]
}

@test "[macos] install_rosetta skips installation when Rosetta is present" {
    touch "${ROSETTA_PATH}"

    run install_rosetta
    [ "${status}" -eq 0 ]
    [ ! -e "${SOFTWAREUPDATE_CALLS_PATH}" ]
}

@test "[macos] main installs Rosetta when it is missing" {
    run main
    [ "${status}" -eq 0 ]
    [ "$(< "${SOFTWAREUPDATE_CALLS_PATH}")" = "--install-rosetta --agree-to-license" ]
}
