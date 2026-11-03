#!/usr/bin/env bats

# @file tests/shell/dot_zshenv.bats
# @brief Behavioural tests for the mise shims PATH bootstrap in home/dot_zshenv.
#
# Each test sources the shipped file in a throwaway `zsh -f` with a controlled
# HOME and PATH, so the assertions exercise the PATH manipulation for real
# instead of matching source text.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="${BATS_TEST_DIRNAME}/../../home/dot_zshenv"

function setup() {
    if ! command -v zsh > /dev/null; then
        skip "zsh is not installed"
    fi

    export TEST_HOME="${BATS_TEST_TMPDIR}/home"
    export SHIMS_DIR="${TEST_HOME}/.local/share/mise/shims"
    export ZSH_BIN
    ZSH_BIN="$(command -v zsh)"
    mkdir -p "${SHIMS_DIR}"

    printf '#!/bin/sh\necho shim\n' > "${SHIMS_DIR}/opencode"
    chmod +x "${SHIMS_DIR}/opencode"
}

# Runs the shipped file in a bare zsh and prints the resulting PATH.
# $1 = PATH value handed to the shell.
function source_with_path() {
    env -i HOME="${TEST_HOME}" PATH="$1" "${ZSH_BIN}" -f -c \
        "source '${SCRIPT_PATH}'; print -r -- \"\${PATH}\""
}

@test "[zshenv] mise shims win over a stale mise install path" {
    local stale_dir="${BATS_TEST_TMPDIR}/stale"
    mkdir -p "${stale_dir}"
    printf '#!/bin/sh\necho stale\n' > "${stale_dir}/opencode"
    chmod +x "${stale_dir}/opencode"

    run env -i HOME="${TEST_HOME}" PATH="${stale_dir}:/usr/bin:/bin" "${ZSH_BIN}" -f -c \
        "source '${SCRIPT_PATH}'; opencode; print -r -- \"\${PATH}\""

    [ "${status}" -eq 0 ]
    [ "${lines[0]}" = "shim" ]
    [[ "${lines[1]}" == "${SHIMS_DIR}:"* ]]
    [[ "${lines[1]}" == *":${stale_dir}:"* ]]
}

@test "[zshenv] duplicates collapse to one leading shims entry" {
    run source_with_path "${SHIMS_DIR}:/x:${SHIMS_DIR}:/usr/bin"

    [ "${status}" -eq 0 ]
    [ "${output}" = "${SHIMS_DIR}:/x:/usr/bin" ]
}

@test "[zshenv] sourcing twice is idempotent" {
    run env -i HOME="${TEST_HOME}" PATH="/x" "${ZSH_BIN}" -f -c \
        "source '${SCRIPT_PATH}'; source '${SCRIPT_PATH}'; print -r -- \"\${PATH}\""

    [ "${status}" -eq 0 ]
    [ "${output}" = "${SHIMS_DIR}:/x" ]
}

@test "[zshenv] leaves PATH alone when the shims directory is absent" {
    export TEST_HOME="${BATS_TEST_TMPDIR}/no-mise"

    run source_with_path "/usr/bin:/bin"

    [ "${status}" -eq 0 ]
    [ "${output}" = "/usr/bin:/bin" ]
}
