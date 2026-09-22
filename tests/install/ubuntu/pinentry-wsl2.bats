#!/usr/bin/env bats

# @file tests/install/ubuntu/pinentry-wsl2.bats
# @brief Tests for the WSL2-aware rbw pinentry selection logic in the chezmoi
#   template (home/.chezmoitemplates/common/rbw).
#
# The template is a Go template (chezmoi syntax), so it cannot be sourced like
# a shell script. We verify the branch logic structurally with grep assertions
# against the template source, matching the approach used by
# system-select-wsl2.bats. This is deterministic and CI-safe (CI does not
# install chezmoi, so a render-based assertion cannot be relied upon).
#
# FR-004 / SC-006: In a WSL2 environment the rbw pinentry SHALL be a TTY-based
#   pinentry program. FR-006: WSL2 support SHALL NOT change native macOS or
#   native Linux behavior.
#
# A behavioral render test (guarded by chezmoi availability) is also included
# to confirm the template actually parses and renders.

bats_require_minimum_version 1.5.0

# Path to the rbw pinentry template, relative to the repo root (the working
# directory when bats runs with -r tests/install/ubuntu/).
readonly TEMPLATE="./home/.chezmoitemplates/common/rbw"

# @test The template must detect WSL2 via the WSL_DISTRO_NAME environment
#   variable. FR-004 / SC-006: WSL2 detection mechanism is present.
@test "[ubuntu] rbw template detects WSL2 via WSL_DISTRO_NAME" {
    [ -f "${TEMPLATE}" ]
    grep -q 'env "WSL_DISTRO_NAME"' "${TEMPLATE}"
}

# @test Inside the WSL2 branch the template must prefer pinentry-tty (a
#   TTY-based pinentry that works without a native X11/Wayland display).
#   FR-004 / SC-006.
@test "[ubuntu] rbw template prefers pinentry-tty in the WSL2 branch" {
    [ -f "${TEMPLATE}" ]

    # The WSL2 branch body (the 4 lines following `if env "WSL_DISTRO_NAME"`)
    # must assign $pinentry = "pinentry-tty".
    grep -A4 'if env "WSL_DISTRO_NAME"' "${TEMPLATE}" |
        grep -q '\$pinentry = "pinentry-tty"'
}

# @test Native Linux (non-WSL2) behavior must be preserved: the else branch
#   keeps the pinentry-curses -> pinentry-tty -> default order. FR-006.
@test "[ubuntu] rbw template preserves native Linux pinentry order in else branch" {
    [ -f "${TEMPLATE}" ]

    # Capture the else branch (the block following `{{-   else }}`).
    local block curses_pos tty_pos
    block="$(grep -A6 '{{-   else }}' "${TEMPLATE}")"

    # Both pinentry-curses and pinentry-tty must be present in the else branch.
    echo "${block}" | grep -q 'pinentry-curses'
    echo "${block}" | grep -q 'pinentry-tty'

    # pinentry-curses must be preferred over pinentry-tty (curses first).
    # Take the first match of each: pinentry-tty appears in both the `else if`
    # condition and the assignment within the else branch.
    curses_pos="$(echo "${block}" | grep -n 'pinentry-curses' | head -1 | cut -d: -f1)"
    tty_pos="$(echo "${block}" | grep -n 'pinentry-tty' | head -1 | cut -d: -f1)"
    [ -n "${curses_pos}" ]
    [ -n "${tty_pos}" ]
    [ "${curses_pos}" -lt "${tty_pos}" ]
}

# @test The WSL2 branch must be wrapped in `if eq .chezmoi.os "linux"` so that
#   macOS is unaffected. FR-006.
@test "[ubuntu] rbw template wraps WSL2 branch in linux os guard" {
    [ -f "${TEMPLATE}" ]

    local linux_line wsl_line
    linux_line="$(grep -n 'eq .chezmoi.os "linux"' "${TEMPLATE}" | cut -d: -f1)"
    wsl_line="$(grep -n 'env "WSL_DISTRO_NAME"' "${TEMPLATE}" | cut -d: -f1)"

    [ -n "${linux_line}" ]
    [ -n "${wsl_line}" ]
    # The linux guard must appear before the WSL2 branch.
    [ "${linux_line}" -lt "${wsl_line}" ]
}

# @test The fallback to the default "pinentry" must be present: if no
#   pinentry binary is found (e.g. pinentry-tty unavailable in WSL2), the
#   default "pinentry" is used. FR-004 / SC-006.
@test "[ubuntu] rbw template falls back to default pinentry" {
    [ -f "${TEMPLATE}" ]

    # The default is initialized before the os/WSL2 branching.
    grep -q '\$pinentry := "pinentry"' "${TEMPLATE}"
    # The rendered config emits the selected pinentry.
    grep -q '"pinentry": "{{ \$pinentry }}"' "${TEMPLATE}"
}

# @test Behavioral: the template must actually render with chezmoi
#   execute-template. This guards against template syntax errors that would
#   break `chezmoi apply` entirely. Skipped when chezmoi is not installed
#   (CI does not install chezmoi).
@test "[ubuntu] rbw template renders with chezmoi execute-template" {
    command -v chezmoi >/dev/null 2>&1 || skip "chezmoi not installed"

    # Use an isolated HOME so the user's real chezmoi config does not
    # interfere with the render.
    local iso_home="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${iso_home}"

    local out status
    out="$(HOME="${iso_home}" chezmoi execute-template \
        --init --override-data '{"email":"test@example.com"}' < "${TEMPLATE}" 2>&1)"
    status=$?

    [ "${status}" -eq 0 ]
    echo "${out}" | grep -q '"pinentry"'
}
