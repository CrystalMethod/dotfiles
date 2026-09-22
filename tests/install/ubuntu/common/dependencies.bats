#!/usr/bin/env bats

# @file tests/install/ubuntu/common/dependencies.bats
# @brief Unit tests for install/ubuntu/common/dependencies.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/ubuntu/common/dependencies.sh"

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

@test "[ubuntu] install_brew_packages skips brew install when all packages are installed" {
    printf '%s\n' cmake git gpg vim zsh > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages "${BREW_PACKAGES[@]}"
    [ "${status}" -eq 0 ]
    run ! grep -q '^install --force ' "${BREW_CALLS_PATH}"
}

@test "[ubuntu] install_brew_packages installs only the missing packages" {
    printf '%s\n' cmake git > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages "${BREW_PACKAGES[@]}"
    [ "${status}" -eq 0 ]
    [ "$(< "${BREW_CALLS_PATH}")" = $'list cmake\nlist git\nlist gpg\nlist vim\nlist zsh\ninstall --force gpg vim zsh' ]
}

@test "[ubuntu] install_brew_packages shows brew info instead of installing in CI" {
    export CI=true

    run install_brew_packages "${BREW_PACKAGES[@]}"
    [ "${status}" -eq 0 ]
    grep -q '^install --force cmake git gpg vim zsh$' "${BREW_CALLS_PATH}"
}

@test "[ubuntu] main installs the missing packages" {
    run main
    [ "${status}" -eq 0 ]
    grep -q '^install --force cmake git gpg vim zsh$' "${BREW_CALLS_PATH}"
}
