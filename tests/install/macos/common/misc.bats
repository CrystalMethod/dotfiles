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

@test "[macos] macOS misc.sh BREW_PACKAGES holds optional macOS packages, not common rbw" {
    source "./install/macos/common/misc.sh"
    [ "${BREW_PACKAGES[*]}" = "ast-grep bash colima docker docker-buildx docker-compose openjdk@21" ]
    # rbw lives in install/common/misc.sh (common requirement, all platforms)
    [[ " ${BREW_PACKAGES[*]} " != *" rbw "* ]]
}

@test "[macos] macOS misc.sh main installs the optional packages" {
    source "./install/macos/common/misc.sh"

    run main
    [ "${status}" -eq 0 ]
    grep -q '^install --force ast-grep bash colima docker docker-buildx docker-compose openjdk@21$' "${BREW_CALLS_PATH}"
}
