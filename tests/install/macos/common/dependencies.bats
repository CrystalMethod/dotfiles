#!/usr/bin/env bats

# @file tests/install/macos/common/dependencies.bats
# @brief Unit tests for install/macos/common/dependencies.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/macos/common/dependencies.sh"

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
    printf 'gpg\n' > "${INSTALLED_PACKAGES_FILE}"

    run is_brew_package_installed gpg
    [ "${status}" -eq 0 ]
}

@test "[macos] is_brew_package_installed reports missing packages" {
    run is_brew_package_installed gpg
    [ "${status}" -ne 0 ]
}

@test "[macos] install_brew_packages skips brew install when all packages are installed" {
    printf '%s\n' cmake git gpg pinentry-mac vim zsh > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages
    [ "${status}" -eq 0 ]
    run ! grep -q '^install --force ' "${BREW_CALLS_PATH}"
}

@test "[macos] install_brew_packages installs only the missing packages" {
    printf '%s\n' cmake git > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages
    [ "${status}" -eq 0 ]
    [ "$(< "${BREW_CALLS_PATH}")" = $'list cmake\nlist git\nlist gpg\nlist pinentry-mac\nlist vim\nlist zsh\ninstall --force gpg pinentry-mac vim zsh' ]
}

@test "[macos] install_brew_packages shows brew info instead of installing in CI" {
    printf '%s\n' cmake git > "${INSTALLED_PACKAGES_FILE}"
    export CI=true

    run install_brew_packages
    [ "${status}" -eq 0 ]
    run ! grep -q '^install --force ' "${BREW_CALLS_PATH}"
    grep -q '^info gpg pinentry-mac vim zsh$' "${BREW_CALLS_PATH}"
}

@test "[macos] main installs the missing packages" {
    printf 'cmake\n' > "${INSTALLED_PACKAGES_FILE}"

    run main
    [ "${status}" -eq 0 ]
    grep -q '^install --force git gpg pinentry-mac vim zsh$' "${BREW_CALLS_PATH}"
}
