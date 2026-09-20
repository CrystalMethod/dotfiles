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

    cat > "${data_file}" <<EOF
{
  "chezmoi": { "os": "linux", "arch": "arm64", "homeDir": "${home_dir}" },
  "mode": "user",
  "system": "client"
}
EOF

    chezmoi execute-template --override-data-file "${data_file}" < "${TEMPLATE_PATH}"
}

@test "[zprofile] linux: evals brew shellenv from \${HOME}/.linuxbrew when present" {
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
    local home_dir="${BATS_TEST_TMPDIR}/nobrew"
    mkdir -p "${home_dir}"

    run render_linux "${home_dir}"
    [ "${status}" -eq 0 ]

    [[ "${output}" != *"brew shellenv"* ]]
}

@test "[zprofile] linux: evals brew shellenv from /home/linuxbrew when present" {
    local brew_path="/home/linuxbrew/.linuxbrew/bin/brew"
    if ! mkdir -p "$(dirname "${brew_path}")" 2>/dev/null; then
        skip "cannot create ${brew_path} on this host (SIP-protected /home)"
    fi
    touch "${brew_path}"

    local home_dir="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${home_dir}"

    run render_linux "${home_dir}"
    [ "${status}" -eq 0 ]

    [[ "${output}" == *"eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""* ]]
}
