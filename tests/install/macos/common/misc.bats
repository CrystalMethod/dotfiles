#!/usr/bin/env bats

# @file tests/install/macos/common/misc.bats
# @brief Unit tests for install/macos/common/misc.sh.

bats_require_minimum_version 1.5.0

function setup() {
    export BREW_CALLS_PATH="${BATS_TEST_TMPDIR}/brew_calls.txt"
    export INSTALLED_PACKAGES_FILE="${BATS_TEST_TMPDIR}/installed.txt"
    : > "${INSTALLED_PACKAGES_FILE}"

    cat > "${BATS_TEST_TMPDIR}/brew" << 'BREW'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${BREW_CALLS_PATH}"
if [ "$1" = "list" ]; then
    while IFS= read -r installed; do
        if [ -n "${installed}" ] && [ "$2" = "${installed}" ]; then
            exit 0
        fi
    done < "${INSTALLED_PACKAGES_FILE}"
    exit 1
fi
BREW
    chmod +x "${BATS_TEST_TMPDIR}/brew"

    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH
}

@test "[macos] macOS misc.sh BREW_PACKAGES contains bash only" {
    source "./install/macos/common/misc.sh"
    [[ " ${BREW_PACKAGES[*]} " == *" bash "* ]]
    [[ " ${BREW_PACKAGES[*]} " != *" rbw "* ]]
}

@test "[macos] macOS misc.sh main installs bash" {
    source "./install/macos/common/misc.sh"

    run main
    [ "${status}" -eq 0 ]
    grep -q '^install --force bash$' "${BREW_CALLS_PATH}"
}
