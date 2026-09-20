#!/usr/bin/env bats

# @file tests/install/common/brew.bats
# @brief Unit tests for install/common/brew.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/common/brew.sh"

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

    PATH="${BATS_TEST_TMPDIR}:${PATH}"
    export PATH

    source "${SCRIPT_PATH}"
}

@test "[common] install_brew_packages installs missing packages with brew install --force" {
    run install_brew_packages "rbw" "fzf"
    [ "${status}" -eq 0 ]
    [ "$(< "${BREW_CALLS_PATH}")" = $'list rbw\nlist fzf\ninstall --force rbw fzf' ]
}

@test "[common] install_brew_packages installs only the missing packages" {
    printf 'rbw\n' > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages "rbw" "fzf"
    [ "${status}" -eq 0 ]
    [ "$(< "${BREW_CALLS_PATH}")" = $'list rbw\nlist fzf\ninstall --force fzf' ]
}

@test "[common] install_brew_packages does not call brew install when all packages are installed" {
    printf 'rbw\nfzf\n' > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages "rbw" "fzf"
    [ "${status}" -eq 0 ]
    run ! grep -q '^install ' "${BREW_CALLS_PATH}"
    [ "$(< "${BREW_CALLS_PATH}")" = $'list rbw\nlist fzf' ]
}

@test "[common] install_brew_packages installs missing packages when CI is set to true" {
    export CI="true"

    run install_brew_packages "rbw"
    [ "${status}" -eq 0 ]
    [ "$(< "${BREW_CALLS_PATH}")" = $'list rbw\ninstall --force rbw' ]
}

@test "[common] install_brew_packages installs missing packages when CI is unset" {
    unset CI

    run install_brew_packages "rbw"
    [ "${status}" -eq 0 ]
    [ "$(< "${BREW_CALLS_PATH}")" = $'list rbw\ninstall --force rbw' ]
}

@test "[common] install_brew_packages does not call brew install when all installed and CI is set" {
    export CI="true"
    printf 'rbw\n' > "${INSTALLED_PACKAGES_FILE}"

    run install_brew_packages "rbw"
    [ "${status}" -eq 0 ]
    run ! grep -q '^install ' "${BREW_CALLS_PATH}"
}

@test "[common] install_brew_packages with no packages does not call brew" {
    run install_brew_packages
    [ "${status}" -eq 0 ]
    [ ! -e "${BREW_CALLS_PATH}" ]
}

@test "[common] is_brew_package_installed returns 0 for an installed package" {
    printf 'rbw\n' > "${INSTALLED_PACKAGES_FILE}"

    run is_brew_package_installed "rbw"
    [ "${status}" -eq 0 ]
}

@test "[common] is_brew_package_installed returns non-zero for a missing package" {
    run is_brew_package_installed "not-installed"
    [ "${status}" -ne 0 ]
}
