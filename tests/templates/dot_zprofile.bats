#!/usr/bin/env bats

# @file tests/templates/dot_zprofile.bats
# @brief Template rendering tests for home/dot_zprofile.tmpl.
#
# Verifies the Linux/WSL2 brew shellenv branch added to the darwin-gated
# block. Rendering is done with `chezmoi execute-template` so the template
# functions (stat, joinPath) and the .chezmoi data model are exercised for
# real.

bats_require_minimum_version 1.5.0

readonly TEMPLATE_PATH="home/dot_zprofile.tmpl"

# Renders the template for the Linux OS with the given home directory.
# $1 = homeDir to inject via --override-data-file.
function render_linux() {
    local home_dir="$1"
    local data_file="${BATS_TEST_TMPDIR}/data.json"

    cat > "${data_file}" << EOF
{
  "chezmoi": { "os": "linux", "arch": "arm64", "homeDir": "${home_dir}" },
  "mode": "user",
  "system": "client"
}
EOF

    chezmoi execute-template --override-data-file "${data_file}" < "${TEMPLATE_PATH}"
}

# Renders the template for the Darwin OS with the given home directory.
# $1 = homeDir to inject via --override-data-file.
function render_darwin() {
    local home_dir="$1"
    local data_file="${BATS_TEST_TMPDIR}/data.json"

    cat > "${data_file}" << EOF
{
  "chezmoi": { "os": "darwin", "arch": "arm64", "homeDir": "${home_dir}" },
  "mode": "user",
  "system": "client"
}
EOF

    chezmoi execute-template --override-data-file "${data_file}" < "${TEMPLATE_PATH}"
}

@test "[zprofile] macOS: includes Bitwarden SSH Agent socket config for dmg path" {
    local home_dir="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${home_dir}"

    # Create the dmg-style socket path
    mkdir -p "${home_dir}/.bitwarden-ssh-agent"
    touch "${home_dir}/.bitwarden-ssh-agent/.bitwarden-ssh-agent.sock"

    run render_darwin "${home_dir}"
    [ "${status}" -eq 0 ]

    # Verify the output contains the expected Bitwarden SSH Agent config
    [[ "${output}" == *"Bitwarden SSH Agent socket"* ]]
    [[ "${output}" == *".bitwarden-ssh-agent.sock"* ]]
    [[ "${output}" == *"SSH_AUTH_SOCK"* ]]
    [[ "${output}" == *"-S"* ]]
}

@test "[zprofile] macOS: includes Bitwarden SSH Agent socket config for store path" {
    local home_dir="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${home_dir}"

    # Create the store path (macOS Container Storage path)
    mkdir -p "${home_dir}/Library/Containers/com.bitwarden.desktop/Data"
    touch "${home_dir}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"

    run render_darwin "${home_dir}"
    [ "${status}" -eq 0 ]

    # Verify the output contains the expected Bitwarden SSH Agent config for store path
    [[ "${output}" == *"Bitwarden SSH Agent socket"* ]]
    [[ "${output}" == *".bitwarden-ssh-agent.sock"* ]]
    [[ "${output}" == *"SSH_AUTH_SOCK"* ]]
    [[ "${output}" == *"-S"* ]]
}

@test "[zprofile] linux: includes Bitwarden SSH Agent socket config" {
    local home_dir="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${home_dir}"

    # Create the Linux socket path
    touch "${home_dir}/.bitwarden-ssh-agent.sock"

    run render_linux "${home_dir}"
    [ "${status}" -eq 0 ]

    # Verify the output contains the expected Bitwarden SSH Agent config
    [[ "${output}" == *"Bitwarden SSH Agent socket"* ]]
    [[ "${output}" == *".bitwarden-ssh-agent.sock"* ]]
    [[ "${output}" == *"SSH_AUTH_SOCK"* ]]
    [[ "${output}" == *"-S"* ]]
}

@test "[zprofile] linux user mode: activates Homebrew from ~/.homebrew" {
    local home_dir="${BATS_TEST_TMPDIR}/user-home"
    mkdir -p "${home_dir}/.homebrew/bin"
    touch "${home_dir}/.homebrew/bin/brew"

    run render_linux "${home_dir}"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"eval \"\$(${home_dir}/.homebrew/bin/brew shellenv)\""* ]]
}

@test "[zprofile] linux: evals brew shellenv from \${HOME}/.linuxbrew when present" {
    if [[ -e "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        skip "host /home/linuxbrew prefix takes precedence"
    fi

    local home_dir="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${home_dir}/.linuxbrew/bin"
    touch "${home_dir}/.linuxbrew/bin/brew"

    run render_linux "${home_dir}"
    [ "${status}" -eq 0 ]

    # The hardcoded /home/linuxbrew prefix does not exist here, so the
    # ${HOME}/.linuxbrew branch must be selected and rendered.
    [[ "${output}" != *"/home/linuxbrew/.linuxbrew/bin/brew shellenv"* ]]
    [[ "${output}" == *"eval \"\$(${home_dir}/.linuxbrew/bin/brew shellenv)\""* ]]
}

@test "[zprofile] linux: is a no-op when no brew prefix exists" {
    if [[ -e "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        skip "host /home/linuxbrew prefix is present"
    fi

    local home_dir="${BATS_TEST_TMPDIR}/nobrew"
    mkdir -p "${home_dir}"

    run render_linux "${home_dir}"
    [ "${status}" -eq 0 ]

    [[ "${output}" != *"brew shellenv"* ]]
}

@test "[zprofile] linux: evals brew shellenv from /home/linuxbrew when present" {
    local brew_path="/home/linuxbrew/.linuxbrew/bin/brew"
    if [[ ! -e "${brew_path}" ]]; then
        skip "host /home/linuxbrew prefix is absent"
    fi

    local home_dir="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${home_dir}"

    run render_linux "${home_dir}"
    [ "${status}" -eq 0 ]

    [[ "${output}" == *"eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""* ]]
}
