#!/usr/bin/env bats

# @file tests/templates/rbw.bats
# @brief Template rendering tests for home/.chezmoitemplates/common/rbw.
#
# Verifies the per-OS pinentry selection added to the shared rbw template:
#   - macOS always renders "pinentry".
#   - Linux prefers pinentry-curses when /usr/bin/pinentry-curses exists,
#     falls back to pinentry-tty when only /usr/bin/pinentry-tty exists,
#     and otherwise falls back to the default "pinentry".
#   - The rendered output is valid, parseable JSON.
#
# Rendering is done with `chezmoi execute-template` so the template functions
# (stat) and the .chezmoi data model are exercised for real. The Linux
# "present" branches require writing to /usr/bin, which is SIP-protected on
# macOS; those tests skip on such hosts and run on Linux CI.

bats_require_minimum_version 1.5.0

readonly TEMPLATE_PATH="home/.chezmoitemplates/common/rbw"

# Renders the rbw template for the given OS and email.
# $1 = os value (e.g. "darwin", "linux")
# $2 = email value
function render_rbw() {
    local os="$1"
    local email="$2"
    local data_file="${BATS_TEST_TMPDIR}/data.json"

    cat > "${data_file}" <<EOF
{
  "chezmoi": { "os": "${os}", "arch": "arm64", "homeDir": "/home/test" },
  "email": "${email}"
}
EOF

    chezmoi execute-template --override-data-file "${data_file}" < "${TEMPLATE_PATH}"
}

# Asserts that the rendered output is valid JSON and that the pinentry field
# equals the expected value.
# $1 = expected pinentry value
function assert_pinentry() {
    local expected="$1"
    local pinentry
    pinentry="$(jq -r '.pinentry' <<<"${output}")"
    [ "${status}" -eq 0 ]
    [ "${pinentry}" = "${expected}" ]
}

@test "[rbw] macOS renders pinentry 'pinentry'" {
    run render_rbw "darwin" "test@example.com"
    assert_pinentry "pinentry"
}

@test "[rbw] macOS output is valid JSON" {
    run render_rbw "darwin" "test@example.com"
    [ "${status}" -eq 0 ]
    jq -e . <<<"${output}" >/dev/null
    [ "${output}" != "" ]
}

@test "[rbw] linux: falls back to 'pinentry' when neither binary exists" {
    # Ensure neither /usr/bin/pinentry-curses nor /usr/bin/pinentry-tty exists.
    if [ -e /usr/bin/pinentry-curses ] || [ -e /usr/bin/pinentry-tty ]; then
        skip "host already has a pinentry binary in /usr/bin"
    fi

    run render_rbw "linux" "test@example.com"
    assert_pinentry "pinentry"
}

@test "[rbw] linux: uses 'pinentry-curses' when /usr/bin/pinentry-curses exists" {
    if ! touch /usr/bin/pinentry-curses 2>/dev/null; then
        skip "cannot write /usr/bin/pinentry-curses on this host (SIP-protected /usr/bin)"
    fi

    run render_rbw "linux" "test@example.com"
    assert_pinentry "pinentry-curses"
}

@test "[rbw] linux: uses 'pinentry-tty' when only /usr/bin/pinentry-tty exists" {
    if ! touch /usr/bin/pinentry-tty 2>/dev/null; then
        skip "cannot write /usr/bin/pinentry-tty on this host (SIP-protected /usr/bin)"
    fi

    run render_rbw "linux" "test@example.com"
    assert_pinentry "pinentry-tty"
}

@test "[rbw] linux output is valid JSON" {
    run render_rbw "linux" "test@example.com"
    [ "${status}" -eq 0 ]
    jq -e . <<<"${output}" >/dev/null
    [ "${output}" != "" ]
}
