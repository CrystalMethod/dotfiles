#!/usr/bin/env bats

# @file tests/install/ubuntu/system-select-wsl2.bats
# @brief Tests for the WSL2 system auto-selection logic in the chezmoi config
#   template (home/.chezmoi.yaml.tmpl).
#
# The template is a Go template (chezmoi syntax), so it cannot be sourced like
# a shell script. We verify the branch logic structurally with grep assertions
# against the template source. This is deterministic and CI-safe: chezmoi
# execute-template --init loads the real config data (which already pins
# `system: client`), so a render-based assertion cannot discriminate the WSL2
# branch from the explicit `.system` override. Source-structure assertions
# directly verify the branch ordering and assignments required by FR-002,
# SC-003 and SC-004.

bats_require_minimum_version 1.5.0

# Path to the chezmoi config template, relative to the repo root (the working
# directory when bats runs with -r tests/install/ubuntu/).
readonly TEMPLATE="./home/.chezmoi.yaml.tmpl"

# @test The template must contain the WSL2 branch and auto-select "client".
#   FR-002 / SC-003: when WSL_DISTRO_NAME is set (WSL2), $system is set to
#   "client" without prompting.
@test "[ubuntu] template auto-selects client on WSL2 via WSL_DISTRO_NAME" {
    [ -f "${TEMPLATE}" ]

    # The WSL2 branch must be present.
    grep -q 'else if env "WSL_DISTRO_NAME"' "${TEMPLATE}"

    # The branch body must assign $system = "client".
    grep -A1 'else if env "WSL_DISTRO_NAME"' "${TEMPLATE}" |
        grep -q '\$system = "client"'
}

# @test The WSL2 branch must be ordered between the darwin check and the
#   promptString fallback, so native Linux still reaches the prompt.
#   SC-004: native Linux (not WSL2) preserves the interactive prompt.
@test "[ubuntu] WSL2 branch sits between darwin check and promptString fallback" {
    [ -f "${TEMPLATE}" ]

    local darwin_line prompt_line wsl_line
    darwin_line="$(grep -n 'eq .chezmoi.os "darwin"' "${TEMPLATE}" | cut -d: -f1)"
    wsl_line="$(grep -n 'env "WSL_DISTRO_NAME"' "${TEMPLATE}" | cut -d: -f1)"
    prompt_line="$(grep -n 'promptString "System (client or server)"' "${TEMPLATE}" | cut -d: -f1)"

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
@test "[ubuntu] template preserves promptString fallback for native Linux" {
    [ -f "${TEMPLATE}" ]
    grep -q 'promptString "System (client or server)"' "${TEMPLATE}"
}

# @test The darwin auto-client behavior must be preserved.
@test "[ubuntu] template preserves darwin auto-client behavior" {
    [ -f "${TEMPLATE}" ]

    grep -q 'eq .chezmoi.os "darwin"' "${TEMPLATE}"
    grep -A1 'eq .chezmoi.os "darwin"' "${TEMPLATE}" |
        grep -q '\$system = "client"'
}

# @test The explicit .system override must be preserved.
@test "[ubuntu] template preserves explicit .system override" {
    [ -f "${TEMPLATE}" ]

    grep -q 'hasKey . "system"' "${TEMPLATE}"
    grep -A1 'hasKey . "system"' "${TEMPLATE}" |
        grep -q '\$system = .system'
}
