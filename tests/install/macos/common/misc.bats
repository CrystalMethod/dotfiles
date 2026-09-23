#!/usr/bin/env bats

# @file tests/install/macos/common/misc.bats
# @brief Unit tests for install/macos/common/misc.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/common/misc.sh"

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

    source "${SCRIPT_PATH}"
}

@test "[macos] is_brew_package_installed reports installed packages" {
    printf 'rbw\n' > "${INSTALLED_PACKAGES_FILE}"

    run is_brew_package_installed rbw
    [ "${status}" -eq 0 ]
}

@test "[macos] is_brew_package_installed reports missing packages" {
    run is_brew_package_installed rbw
    [ "${status}" -ne 0 ]
}

@test "[macos] install_brew_packages skips brew install when all packages are installed" {
    printf 'rbw\n' > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages
    [ "${status}" -eq 0 ]
    run ! grep -q '^install --force ' "${BREW_CALLS_PATH}"
}

@test "[macos] install_brew_packages installs the missing packages" {
    run install_brew_packages "${BREW_PACKAGES[@]}"
    [ "${status}" -eq 0 ]
    [ "$(< "${BREW_CALLS_PATH}")" = $'list rbw\ninstall --force rbw' ]
}

@test "[macos] install_brew_packages shows brew info instead of installing in CI" {
    export CI=true

    run install_brew_packages "${BREW_PACKAGES[@]}"
    [ "${status}" -eq 0 ]
    grep -q '^install --force rbw$' "${BREW_CALLS_PATH}"
}

@test "[macos] main installs the missing packages" {
    run main
    [ "${status}" -eq 0 ]
    grep -q '^install --force rbw$' "${BREW_CALLS_PATH}"
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
