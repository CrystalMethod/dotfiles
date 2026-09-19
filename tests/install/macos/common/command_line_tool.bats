#!/usr/bin/env bats

# @file tests/install/macos/common/command_line_tool.bats
# @brief Unit tests for install/macos/common/command_line_tool.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/macos/common/command_line_tool.sh"
readonly GIT_CMD_PATH="/Library/Developer/CommandLineTools/usr/bin/git"

function setup() {
    source "${SCRIPT_PATH}"
}

@test "[macos] command_line_tool reports when tools are already installed" {
    if [ ! -e "${GIT_CMD_PATH}" ]; then
        skip "Xcode Command Line Tools are not installed"
    fi

    run install_command_line_tool
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Command line developer tools are installed."* ]]
}

@test "[macos] command_line_tool triggers xcode-select when tools are missing" {
    if [ -e "${GIT_CMD_PATH}" ]; then
        skip "Xcode Command Line Tools are installed; cannot exercise the install branch"
    fi

    local xcode_calls="${BATS_TEST_TMPDIR}/xcode_calls.txt"
    export XCODE_CALLS_PATH="${xcode_calls}"

    cat > "${BATS_TEST_TMPDIR}/xcode-select" << EOF
#!/usr/bin/env bash
printf '%s\n' "\$*" >> "\${XCODE_CALLS_PATH}"
EOF
    chmod +x "${BATS_TEST_TMPDIR}/xcode-select"
    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    run bash -c 'printf "x" | install_command_line_tool'
    [ "${status}" -eq 0 ]
    [ "$(< "${xcode_calls}")" = "--install" ]
}

@test "[macos] script enables xtrace when DOTFILES_DEBUG is set" {
    run env DOTFILES_DEBUG=1 bash -c '
        source "'"${SCRIPT_PATH}"'"
        case "$-" in
            *x*) exit 0 ;;
            *) exit 1 ;;
        esac
    '
    [ "${status}" -eq 0 ]
}
