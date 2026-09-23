#!/usr/bin/env bats

# @file tests/install/ubuntu/wsl2.bats
# @brief Comprehensive WSL2 test suite covering all four WSL2 behavior areas:
#   detection, system auto-selection, sudo keepalive, and pinentry fallback.
#
# The four WSL2 behavior areas (FR-005, SC-001..SC-007):
#   1. Detection        — install/common/wsl2.sh is_wsl2() (behavioral).
#   2. System selection — home/.chezmoi.yaml.tmpl auto-selects "client" on
#                         WSL2 (source-structure; Go template cannot be sourced).
#   3. Sudo keepalive   — setup.sh keepalive_sudo_linux() is WSL2-aware
#                         (source-structure).
#   4. Pinentry         — home/.chezmoitemplates/common/rbw prefers pinentry-tty
#                         in WSL2 (source-structure; Go template cannot be sourced).
#
# The Go templates (home/.chezmoi.yaml.tmpl and
# home/.chezmoitemplates/common/rbw) cannot be sourced like shell scripts, so
# their branch logic is verified with deterministic source-structure grep
# assertions, matching the approach used by the sibling WSL2 test files. This is
# CI-safe: CI does not install chezmoi, so a render-based assertion cannot be
# relied upon.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/common/wsl2.sh"
readonly SETUP_PATH="./setup.sh"
readonly CONFIG_TEMPLATE="./home/.chezmoi.yaml.tmpl"
readonly RBW_TEMPLATE="./home/.chezmoitemplates/common/rbw"

function setup() {
    export UNAME_RELEASE_FILE="${BATS_TEST_TMPDIR}/uname_release.txt"
    : > "${UNAME_RELEASE_FILE}"

    # Stub `uname` so that `uname -r` returns the configured release while the
    # real `uname` remains reachable for any other invocation.
    cat > "${BATS_TEST_TMPDIR}/uname" << 'UNAME'
#!/usr/bin/env bash
if [ "${1:-}" = "-r" ]; then
    cat "${UNAME_RELEASE_FILE}"
    exit 0
fi
exit 1
UNAME
    chmod +x "${BATS_TEST_TMPDIR}/uname"

    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    source "${SCRIPT_PATH}"
}

function mock_uname_release() {
    printf '%s\n' "$1" > "${UNAME_RELEASE_FILE}"
}

# ---------------------------------------------------------------------------
# Area 1 — WSL2 detection (install/common/wsl2.sh is_wsl2)
# ---------------------------------------------------------------------------

@test "[ubuntu] is_wsl2 returns 0 when kernel release contains microsoft" {
    mock_uname_release "5.15.153.1-microsoft-standard-WSL2"

    run is_wsl2
    [ "${status}" -eq 0 ]
}

@test "[ubuntu] is_wsl2 returns non-zero when kernel release lacks microsoft" {
    mock_uname_release "6.8.0-45-generic"

    run is_wsl2
    [ "${status}" -ne 0 ]
}

@test "[ubuntu] is_wsl2 is case-insensitive (Microsoft matches)" {
    mock_uname_release "5.15.153.1-Microsoft-standard-WSL2"

    run is_wsl2
    [ "${status}" -eq 0 ]
}

@test "[ubuntu] sourcing wsl2.sh has no side effects" {
    run bash -c 'source ./install/common/wsl2.sh'
    [ "${status}" -eq 0 ]
    [ -z "${output}" ]
}

# ---------------------------------------------------------------------------
# Area 2 — WSL2 system auto-selection (home/.chezmoi.yaml.tmpl)
# ---------------------------------------------------------------------------

# @test The config template must contain the WSL2 branch and auto-select
#   "client". FR-005 / SC-003: when WSL_DISTRO_NAME is set (WSL2), $system is
#   set to "client" without prompting.
@test "[ubuntu] config template auto-selects client on WSL2 via WSL_DISTRO_NAME" {
    [ -f "${CONFIG_TEMPLATE}" ]

    # The WSL2 branch must be present.
    grep -q 'else if env "WSL_DISTRO_NAME"' "${CONFIG_TEMPLATE}"

    # The branch body must assign $system = "client".
    grep -A1 'else if env "WSL_DISTRO_NAME"' "${CONFIG_TEMPLATE}" |
        grep -q '\$system = "client"'
}

# @test The WSL2 branch must be ordered between the darwin check and the
#   promptString fallback, so native Linux still reaches the prompt.
#   SC-004: native Linux (not WSL2) preserves the interactive prompt.
@test "[ubuntu] config template WSL2 branch sits between darwin check and prompt fallback" {
    [ -f "${CONFIG_TEMPLATE}" ]

    local darwin_line wsl_line prompt_line
    darwin_line="$(grep -n 'eq .chezmoi.os "darwin"' "${CONFIG_TEMPLATE}" | cut -d: -f1)"
    wsl_line="$(grep -n 'env "WSL_DISTRO_NAME"' "${CONFIG_TEMPLATE}" | cut -d: -f1)"
    prompt_line="$(grep -n 'promptString "System (client or server)"' "${CONFIG_TEMPLATE}" | cut -d: -f1)"

    [ -n "${darwin_line}" ]
    [ -n "${wsl_line}" ]
    [ -n "${prompt_line}" ]

    # darwin < WSL2 < promptString
    [ "${darwin_line}" -lt "${wsl_line}" ]
    [ "${wsl_line}" -lt "${prompt_line}" ]
}

# @test The promptString fallback for native Linux must be preserved.
#   SC-004: native Linux shows the interactive "System (client or server)"
#   prompt.
@test "[ubuntu] config template preserves promptString fallback for native Linux" {
    [ -f "${CONFIG_TEMPLATE}" ]
    grep -q 'promptString "System (client or server)"' "${CONFIG_TEMPLATE}"
}

# ---------------------------------------------------------------------------
# Area 3 — WSL2 sudo keepalive (setup.sh keepalive_sudo_linux)
# ---------------------------------------------------------------------------

# @test keepalive_sudo_linux() must have a dry-run guard that returns early
#   without invoking sudo. FR-005 / SC-005: no hang/failure in dry-run.
@test "[ubuntu] keepalive_sudo_linux has a dry-run guard" {
    [ -f "${SETUP_PATH}" ]

    # The dry-run guard must be present inside keepalive_sudo_linux.
    grep -q 'is_dry_run' "${SETUP_PATH}"
    grep -q '\[dry-run\] Would keep sudo alive (sudo -v / sudo keep-alive loop).' "${SETUP_PATH}"
}

# @test keepalive_sudo_linux() must be WSL2-aware: it branches on is_wsl2 and
#   skips the interactive `sudo -v` prompt when there is no TTY. SC-005.
@test "[ubuntu] keepalive_sudo_linux is WSL2-aware and skips sudo -v without a TTY" {
    [ -f "${SETUP_PATH}" ]

    # The function must branch on is_wsl2.
    grep -q 'is_wsl2' "${SETUP_PATH}"
    # It must consult is_tty to decide whether to prompt.
    grep -q 'is_tty' "${SETUP_PATH}"
    # The non-interactive WSL2 notice must be present.
    grep -q 'Non-interactive WSL2: skipping sudo password prompt.' "${SETUP_PATH}"
}

# @test Native Linux sudo behavior must be unchanged: the interactive `sudo -v`
#   prompt is still invoked in the else branch. FR-006.
@test "[ubuntu] keepalive_sudo_linux preserves native Linux sudo -v prompt" {
    [ -f "${SETUP_PATH}" ]

    # The interactive sudo -v prompt must be preserved. The backticks in the
    # source are backslash-escaped (inside double quotes a bare backtick would
    # trigger command substitution), so match the literal escaped form with
    # grep -F (fixed string) to avoid regex interpretation.
    grep -q 'sudo -v' "${SETUP_PATH}"
    grep -Fq 'Checking for \`sudo\` access which may request your password.' "${SETUP_PATH}"
}

# @test The keep-alive loop (`sudo -n true` / `sleep 60` / `kill -0 $$`) must be
#   preserved in all cases. FR-005 / SC-005.
@test "[ubuntu] keepalive_sudo_linux preserves the keep-alive loop" {
    [ -f "${SETUP_PATH}" ]

    grep -q 'sudo -n true' "${SETUP_PATH}"
    grep -q 'sleep 60' "${SETUP_PATH}"
    grep -q 'kill -0 "\$\$"' "${SETUP_PATH}"
}

# ---------------------------------------------------------------------------
# Area 4 — WSL2 pinentry fallback (home/.chezmoitemplates/common/rbw)
# ---------------------------------------------------------------------------

# @test The rbw template must detect WSL2 via the WSL_DISTRO_NAME environment
#   variable. FR-005 / SC-006: WSL2 detection mechanism is present.
@test "[ubuntu] rbw template detects WSL2 via WSL_DISTRO_NAME" {
    [ -f "${RBW_TEMPLATE}" ]
    grep -q 'env "WSL_DISTRO_NAME"' "${RBW_TEMPLATE}"
}

# @test Inside the WSL2 branch the template must prefer pinentry-tty (a
#   TTY-based pinentry that works without a native X11/Wayland display).
#   FR-005 / SC-006.
@test "[ubuntu] rbw template prefers pinentry-tty in the WSL2 branch" {
    [ -f "${RBW_TEMPLATE}" ]

    # The WSL2 branch body (the 4 lines following `if env "WSL_DISTRO_NAME"`)
    # must assign $pinentry = "pinentry-tty".
    grep -A4 'if env "WSL_DISTRO_NAME"' "${RBW_TEMPLATE}" |
        grep -q '\$pinentry = "pinentry-tty"'
}

# @test Native Linux (non-WSL2) behavior must be preserved: the else branch
#   keeps the pinentry-curses -> pinentry-tty -> default order. FR-006.
@test "[ubuntu] rbw template preserves native Linux pinentry order in else branch" {
    [ -f "${RBW_TEMPLATE}" ]

    # Capture the else branch (the block following `{{-   else }}`).
    local block curses_pos tty_pos
    block="$(grep -A6 '{{-   else }}' "${RBW_TEMPLATE}")"

    # Both pinentry-curses and pinentry-tty must be present in the else branch.
    echo "${block}" | grep -q 'pinentry-curses'
    echo "${block}" | grep -q 'pinentry-tty'

    # pinentry-curses must be preferred over pinentry-tty (curses first).
    curses_pos="$(echo "${block}" | grep -n 'pinentry-curses' | head -1 | cut -d: -f1)"
    tty_pos="$(echo "${block}" | grep -n 'pinentry-tty' | head -1 | cut -d: -f1)"
    [ -n "${curses_pos}" ]
    [ -n "${tty_pos}" ]
    [ "${curses_pos}" -lt "${tty_pos}" ]
}

# @test The WSL2 branch must be wrapped in `if eq .chezmoi.os "linux"` so that
#   macOS is unaffected. FR-006.
@test "[ubuntu] rbw template wraps WSL2 branch in linux os guard" {
    [ -f "${RBW_TEMPLATE}" ]

    local linux_line wsl_line
    linux_line="$(grep -n 'eq .chezmoi.os "linux"' "${RBW_TEMPLATE}" | cut -d: -f1)"
    wsl_line="$(grep -n 'env "WSL_DISTRO_NAME"' "${RBW_TEMPLATE}" | cut -d: -f1)"

    [ -n "${linux_line}" ]
    [ -n "${wsl_line}" ]
    # The linux guard must appear before the WSL2 branch.
    [ "${linux_line}" -lt "${wsl_line}" ]
}

# @test The fallback to the default "pinentry" must be present: if no pinentry
#   binary is found (e.g. pinentry-tty unavailable in WSL2), the default
#   "pinentry" is used. FR-005 / SC-006.
@test "[ubuntu] rbw template falls back to default pinentry" {
    [ -f "${RBW_TEMPLATE}" ]

    # The default is initialized before the os/WSL2 branching.
    grep -q '\$pinentry := "pinentry"' "${RBW_TEMPLATE}"
    # The rendered config emits the selected pinentry.
    grep -q '"pinentry": "{{ \$pinentry }}"' "${RBW_TEMPLATE}"
}
