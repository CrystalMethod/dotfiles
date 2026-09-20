#!/usr/bin/env bats

# @file tests/install/common/mise.bats
# @brief Unit tests for install/common/mise.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/common/mise.sh"

function setup() {
    export HOME="${BATS_TEST_TMPDIR}/home"
    export TEST_BIN_DIR="${BATS_TEST_TMPDIR}/bin"
    export MISE_INSTALL_PATH="${BATS_TEST_TMPDIR}/bin/mise"
    export MISE_CONFIG_PATH="${BATS_TEST_TMPDIR}/mise_config.toml"
    export MISE_CALLS_PATH="${BATS_TEST_TMPDIR}/mise_calls.txt"
    export CURL_ARGS_PATH="${BATS_TEST_TMPDIR}/curl_args.txt"
    export INSTALLER_ENV_PATH="${BATS_TEST_TMPDIR}/installer_env.txt"

    mkdir -p "${HOME}" "${TEST_BIN_DIR}"
    rm -f "${MISE_CALLS_PATH}" "${CURL_ARGS_PATH}" "${INSTALLER_ENV_PATH}"

    PATH="${TEST_BIN_DIR}:$(getconf PATH)"
    export PATH

    source "${SCRIPT_PATH}"
}

function write_mise_config() {
    local version="$1"
    cat > "${MISE_CONFIG_PATH}" << EOF
min_version = "${version}"

[tools]
EOF
}

function write_mise_stub() {
    local version="${1:-2026.8.15}"
    cat > "${MISE_INSTALL_PATH}" << EOF
#!/usr/bin/env bash
case "\$1" in
    --version)
        printf 'mise ${version}\\n'
        ;;
    install)
        printf 'install\\n' >> "\${MISE_CALLS_PATH}"
        printf 'MISE_CURRENT_VERSION=%s\\n' "\${MISE_CURRENT_VERSION:-}" >> "\${MISE_CALLS_PATH}"
        printf 'MISE_VERSION=%s\\n' "\${MISE_VERSION:-}" >> "\${MISE_CALLS_PATH}"
        ;;
    activate)
        printf 'export PATH="%s:\$PATH"\\n' "\$(dirname "\${MISE_INSTALL_PATH}")"
        ;;
esac
EOF
    chmod +x "${MISE_INSTALL_PATH}"
}

function write_curl_installer_stub() {
    cat > "${TEST_BIN_DIR}/curl" << 'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "${CURL_ARGS_PATH}"
output_path=""
while [ "$#" -gt 0 ]; do
    if [ "$1" = "-o" ]; then
        output_path="$2"
        shift 2
    else
        shift
    fi
done
cat > "${output_path}" << 'INSTALLER'
#!/usr/bin/env bash
printf 'MISE_VERSION=%s\n' "${MISE_VERSION:-}" > "${INSTALLER_ENV_PATH}"
cat > "${MISE_INSTALL_PATH}" << 'MISE'
#!/usr/bin/env bash
case "$1" in
    --version) printf 'mise 2026.8.15\n' ;;
    install)
        printf 'install\n' >> "${MISE_CALLS_PATH}"
        printf 'MISE_CURRENT_VERSION=%s\n' "${MISE_CURRENT_VERSION:-}" >> "${MISE_CALLS_PATH}"
        printf 'MISE_VERSION=%s\n' "${MISE_VERSION:-}" >> "${MISE_CALLS_PATH}"
        ;;
    activate) printf 'export PATH="%s:$PATH"\n' "$(dirname "${MISE_INSTALL_PATH}")" ;;
esac
MISE
chmod +x "${MISE_INSTALL_PATH}"
INSTALLER
EOF
    chmod +x "${TEST_BIN_DIR}/curl"
}

@test "[common] get_mise_min_version_from_config reads top-level min_version" {
    write_mise_config "2026.8.15"
    run get_mise_min_version_from_config "${MISE_CONFIG_PATH}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "2026.8.15" ]
}

@test "[common] get_mise_min_version_from_config rejects malformed min_version" {
    cat > "${MISE_CONFIG_PATH}" << 'EOF'
min_version = "v2026.8.15"

[tools]
EOF
    run get_mise_min_version_from_config "${MISE_CONFIG_PATH}"
    [ "${status}" -ne 0 ]
}

@test "[common] get_mise_min_version_from_config fails on unreadable config" {
    run get_mise_min_version_from_config "${BATS_TEST_TMPDIR}/missing.toml"
    [ "${status}" -ne 0 ]
}

@test "[common] get_mise_release_tag_from_config normalizes the version" {
    write_mise_config "2026.8.15"
    run get_mise_release_tag_from_config "${MISE_CONFIG_PATH}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "v2026.8.15" ]
}

@test "[common] is_mise_version_at_least accepts equal versions" {
    run is_mise_version_at_least "2026.8.15" "2026.8.15"
    [ "${status}" -eq 0 ]
}

@test "[common] is_mise_version_at_least accepts newer versions" {
    run is_mise_version_at_least "2026.9.1" "2026.8.15"
    [ "${status}" -eq 0 ]
}

@test "[common] is_mise_version_at_least rejects older versions" {
    run is_mise_version_at_least "2026.8.14" "2026.8.15"
    [ "${status}" -eq 1 ]
}

@test "[common] is_mise_version_at_least rejects malformed versions" {
    run is_mise_version_at_least "latest" "2026.8.15"
    [ "${status}" -eq 1 ]
}

@test "[common] get_installed_mise_version parses the installed version" {
    write_mise_stub "2026.8.15"
    run get_installed_mise_version
    [ "${status}" -eq 0 ]
    [ "${output}" = "2026.8.15" ]
}

@test "[common] get_installed_mise_version fails when mise is missing" {
    run get_installed_mise_version
    [ "${status}" -ne 0 ]
}

@test "[common] install_mise downloads and installs the configured release" {
    write_mise_config "2026.8.15"
    write_curl_installer_stub

    run install_mise
    [ "${status}" -eq 0 ]
    [ -x "${MISE_INSTALL_PATH}" ]
    [[ "$(< "${CURL_ARGS_PATH}")" == "-fsSL https://github.com/jdx/mise/releases/download/v2026.8.15/install.sh -o "* ]]
    [ "$(< "${INSTALLER_ENV_PATH}")" = "MISE_VERSION=v2026.8.15" ]
}

@test "[common] ensure_mise_min_version skips install when mise is current" {
    write_mise_config "2026.8.15"
    write_mise_stub "2026.8.15"
    write_curl_installer_stub

    run ensure_mise_min_version
    [ "${status}" -eq 0 ]
    [ ! -e "${CURL_ARGS_PATH}" ]
}

@test "[common] ensure_mise_min_version installs stale mise" {
    write_mise_config "2026.8.15"
    write_mise_stub "2026.8.14"
    write_curl_installer_stub

    run ensure_mise_min_version
    [ "${status}" -eq 0 ]
    [ -e "${CURL_ARGS_PATH}" ]
}

@test "[common] ensure_mise_min_version propagates install_mise failure when stale" {
    write_mise_config "2026.8.15"
    write_mise_stub "2026.8.14"

    function install_mise() {
        printf 'install_mise called\n' >> "${BATS_TEST_TMPDIR}/install_calls.txt"
        return 1
    }

    run ensure_mise_min_version
    [ "${status}" -eq 1 ]
    [ "$(< "${BATS_TEST_TMPDIR}/install_calls.txt")" = "install_mise called" ]
}

@test "[common] ensure_mise_min_version returns install_mise exit code when mise missing" {
    write_mise_config "2026.8.15"

    function install_mise() {
        printf 'install_mise called\n' >> "${BATS_TEST_TMPDIR}/install_calls.txt"
        return 3
    }

    run ensure_mise_min_version
    [ "${status}" -eq 3 ]
    [ "$(< "${BATS_TEST_TMPDIR}/install_calls.txt")" = "install_mise called" ]
}

@test "[common] ensure_mise_min_version happy path does not call install_mise" {
    write_mise_config "2026.8.15"
    write_mise_stub "2026.8.15"

    function install_mise() {
        printf 'install_mise called\n' >> "${BATS_TEST_TMPDIR}/install_calls.txt"
        return 1
    }

    run ensure_mise_min_version
    [ "${status}" -eq 0 ]
    [ ! -e "${BATS_TEST_TMPDIR}/install_calls.txt" ]
}

@test "[common] run_mise_install unsets installer envvars" {
    write_mise_stub
    export MISE_CURRENT_VERSION="should-not-leak"
    export MISE_VERSION="should-not-leak"

    run run_mise_install
    [ "${status}" -eq 0 ]
    [ "$(< "${MISE_CALLS_PATH}")" = $'install\nMISE_CURRENT_VERSION=\nMISE_VERSION=' ]
}

@test "[common] main installs, activates, and runs mise install" {
    write_mise_config "2026.8.15"
    write_mise_stub "2026.8.14"
    write_curl_installer_stub

    run main
    [ "${status}" -eq 0 ]
    [ -x "${MISE_INSTALL_PATH}" ]
    [ "$(< "${MISE_CALLS_PATH}")" = $'install\nMISE_CURRENT_VERSION=\nMISE_VERSION=' ]
}
