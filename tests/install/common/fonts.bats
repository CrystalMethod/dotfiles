#!/usr/bin/env bats

# @file tests/install/common/fonts.bats
# @brief Unit tests for install/common/fonts.sh.

bats_require_minimum_version 1.5.0

readonly SCRIPT_PATH="./install/common/fonts.sh"

function setup() {
    export HOME="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${HOME}"
    source "${SCRIPT_PATH}"
}

@test "[common] font_family_dir returns the absolute family path" {
    run font_family_dir ".local/share/fonts/MonoLisa"
    [ "${status}" -eq 0 ]
    [ "${output}" = "${HOME}/.local/share/fonts/MonoLisa" ]
}

@test "[common] refresh_font_cache runs fc-cache when available" {
    local dir="${HOME}/.local/share/fonts/MonoLisa"
    mkdir -p "${dir}"

    # Stub fc-cache on PATH to record invocations.
    export FC_CACHE_CALLS="${BATS_TEST_TMPDIR}/fc_calls.txt"
    : > "${FC_CACHE_CALLS}"
    cat > "${BATS_TEST_TMPDIR}/fc-cache" << 'FCCACHE'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${FC_CACHE_CALLS}"
FCCACHE
    chmod +x "${BATS_TEST_TMPDIR}/fc-cache"
    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    run refresh_font_cache "${dir}"
    [ "${status}" -eq 0 ]
    grep -q "^-f ${dir}$" "${FC_CACHE_CALLS}"
}

@test "[common] refresh_font_cache succeeds when fc-cache is unavailable" {
    # A stub from a previous test may still sit in the tmpdir; hide it.
    if [ -e "${BATS_TEST_TMPDIR}/fc-cache" ]; then
        mv "${BATS_TEST_TMPDIR}/fc-cache" "${BATS_TEST_TMPDIR}/fc-cache.bak"
    fi
    PATH="${BATS_TEST_TMPDIR}:${PATH}" export PATH

    run refresh_font_cache "${HOME}/.local/share/fonts/MonoLisa"
    [ "${status}" -eq 0 ]
}
