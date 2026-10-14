#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

@test "[zprofile] linux user mode activates Homebrew from ~/.homebrew" {
    local home_dir="${BATS_TEST_TMPDIR}/home"
    local data_file="${BATS_TEST_TMPDIR}/data.json"
    mkdir -p "${home_dir}/.homebrew/bin"
    touch "${home_dir}/.homebrew/bin/brew"
    cat > "${data_file}" << EOF
{
  "chezmoi": { "os": "linux", "arch": "arm64", "homeDir": "${home_dir}" },
  "mode": "user",
  "system": "client"
}
EOF

    run chezmoi execute-template --override-data-file "${data_file}" < home/dot_zprofile.tmpl
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"eval \"\$(${home_dir}/.homebrew/bin/brew shellenv)\""* ]]
}
