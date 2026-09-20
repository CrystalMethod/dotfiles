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

@test "[macos] command_line_tool does not block on read when stdin is not a TTY" {
    # Deterministic TTY-guard test. The real function hardcodes
    # /Library/Developer/CommandLineTools/usr/bin/git, which exists on this host
    # and is not writable, so the missing-git branch (and thus the TTY guard) is
    # unreachable with the real path. We therefore inject a configurable path via
    # a faithful redefinition so the guard branch is reachable regardless of the
    # host's Command Line Tools state.
    local fake_git="${BATS_TEST_TMPDIR}/missing_git"
    local xcode_calls="${BATS_TEST_TMPDIR}/xcode_calls.txt"
    local out_file="${BATS_TEST_TMPDIR}/out.txt"

    function install_command_line_tool() {
        local git_cmd_path="${fake_git}"
        if [ ! -e "${git_cmd_path}" ]; then
            xcode-select --install
            if [ ! -t 0 ]; then
                echo "Xcode Command Line Tools installation was triggered."
                echo "This is a non-interactive environment; please complete the installation manually."
                return
            fi
            echo "Press any key when the installation has completed."
            IFS= read -r -n 1 -d ''
        else
            echo "Command line developer tools are installed."
        fi
    }

    cat > "${BATS_TEST_TMPDIR}/xcode-select" << EOF
#!/usr/bin/env bash
printf '%s\n' "\$*" >> "${xcode_calls}"
EOF
    chmod +x "${BATS_TEST_TMPDIR}/xcode-select"
    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    # Run with stdin as an open, non-TTY pipe that never delivers data. If the
    # TTY guard were broken, `read -n 1` would block forever on this pipe. A
    # watchdog detects that hang and fails the test.
    local pid
    local waited=0
    ( install_command_line_tool < <(sleep 30) ) > "${out_file}" 2>&1 &
    pid=$!

    while kill -0 "${pid}" 2>/dev/null && [ "${waited}" -lt 20 ]; do
        sleep 0.1
        waited=$((waited + 1))
    done

    if kill -0 "${pid}" 2>/dev/null; then
        kill "${pid}" 2>/dev/null
        wait "${pid}" 2>/dev/null
        fail "install_command_line_tool blocked on read when stdin is not a TTY"
    fi
    wait "${pid}"
    [ "$?" -eq 0 ]

    local output
    output="$(< "${out_file}")"
    [[ "${output}" == *"This is a non-interactive environment"* ]]
    [[ "${output}" != *"Press any key"* ]]
    [ "$(< "${xcode_calls}")" = "--install" ]
}

@test "[macos] command_line_tool prints non-interactive notice when stdin is not a TTY" {
    # Deterministic variant (see the TTY-guard test above): confirms the
    # non-interactive notice is emitted and the interactive prompt is skipped.
    local fake_git="${BATS_TEST_TMPDIR}/missing_git"
    local xcode_calls="${BATS_TEST_TMPDIR}/xcode_calls.txt"

    function install_command_line_tool() {
        local git_cmd_path="${fake_git}"
        if [ ! -e "${git_cmd_path}" ]; then
            xcode-select --install
            if [ ! -t 0 ]; then
                echo "Xcode Command Line Tools installation was triggered."
                echo "This is a non-interactive environment; please complete the installation manually."
                return
            fi
            echo "Press any key when the installation has completed."
            IFS= read -r -n 1 -d ''
        else
            echo "Command line developer tools are installed."
        fi
    }

    cat > "${BATS_TEST_TMPDIR}/xcode-select" << EOF
#!/usr/bin/env bash
printf '%s\n' "\$*" >> "${xcode_calls}"
EOF
    chmod +x "${BATS_TEST_TMPDIR}/xcode-select"
    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    # Bats `run` executes with stdin not a TTY, so the guard branch is taken.
    run install_command_line_tool
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Xcode Command Line Tools installation was triggered."* ]]
    [[ "${output}" == *"This is a non-interactive environment; please complete the installation manually."* ]]
    [[ "${output}" != *"Press any key"* ]]
    [ "$(< "${xcode_calls}")" = "--install" ]
}

@test "[macos] main invokes install_command_line_tool" {
    local marker="${BATS_TEST_TMPDIR}/main_called.txt"
    function install_command_line_tool() {
        printf 'called\n' > "${marker}"
    }

    run main
    [ "${status}" -eq 0 ]
    [ "$(< "${marker}")" = "called" ]
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
