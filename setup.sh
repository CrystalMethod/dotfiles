#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

# shellcheck disable=SC2016
declare -r DOTFILES_LOGO='
                          /$$                                      /$$
                         | $$                                     | $$
     /$$$$$$$  /$$$$$$  /$$$$$$   /$$   /$$  /$$$$$$      /$$$$$$$| $$$$$$$
    /$$_____/ /$$__  $$|_  $$_/  | $$  | $$ /$$__  $$    /$$_____/| $$__  $$
   |  $$$$$$ | $$$$$$$$  | $$    | $$  | $$| $$  \ $$   |  $$$$$$ | $$  \ $$
    \____  $$| $$_____/  | $$ /$$| $$  | $$| $$  | $$    \____  $$| $$  | $$
    /$$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$/| $$$$$$$//$$ /$$$$$$$/| $$  | $$
   |_______/  \_______/   \___/   \______/ | $$____/|__/|_______/ |__/  |__/
                                           | $$
                                           | $$
                                           |__/

             *** This is setup script for my dotfiles setup ***            
                  https://github.com/crystalmethod/dotfiles
'

declare -r DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-https://github.com/crystalmethod/dotfiles}"
declare -r BRANCH_NAME="${BRANCH_NAME:-main}"

# Run mode: "privileged" (default, uses sudo) or "user" (no sudo, Homebrew in user space).
declare MODE="privileged"

# Dry-run: show what would be done without executing anything.
declare DRY_RUN=false

function is_ci() {
    "${CI:-false}"
}

function is_tty() {
    [ -t 0 ]
}

function is_not_tty() {
    ! is_tty
}

function is_ci_or_not_tty() {
    is_ci || is_not_tty
}

function at_exit() {
    AT_EXIT+="${AT_EXIT:+$'\n'}"
    AT_EXIT+="${*?}"
    # shellcheck disable=SC2064
    trap "${AT_EXIT}" EXIT
}

function usage() {
    cat <<'EOF'
Usage: setup.sh [--mode <privileged|user>] [--dry-run]

Options:
  --mode <mode>   Run mode (default: privileged).
                  privileged: Install Homebrew system-wide using sudo
                              (/opt/homebrew on Apple Silicon, /usr/local on Intel).
                  user:       Install Homebrew in user space (~/.homebrew) without sudo.
  --dry-run       Show what would be done without executing anything.
  -h, --help      Show this help message and exit.
EOF
}

function parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --mode)
                if [[ $# -lt 2 || "$2" == -* ]]; then
                    echo "Error: --mode requires an argument." >&2
                    usage >&2
                    exit 1
                fi
                MODE="$2"
                shift 2
                ;;
            --mode=*)
                MODE="${1#*=}"
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Error: Unknown option: $1" >&2
                usage >&2
                exit 1
                ;;
        esac
    done
}

function validate_mode() {
    case "${MODE}" in
        privileged|user) ;;
        *)
            echo "Error: Invalid mode '${MODE}'. Expected 'privileged' or 'user'." >&2
            usage >&2
            exit 1
            ;;
    esac
}

function is_privileged_mode() {
    [[ "${MODE}" == "privileged" ]]
}

function is_user_mode() {
    [[ "${MODE}" == "user" ]]
}

function is_dry_run() {
    [[ "${DRY_RUN}" == true ]]
}

# Execute a command, or print it with a [dry-run] prefix when --dry-run is active.
function run() {
    if is_dry_run; then
        printf '[dry-run]'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

# Execute a command given as a string, or print it in dry-run mode.
# Use this for commands containing command substitutions ($(...)) that must
# not be evaluated in dry-run mode (e.g. curl-piped installers).
function logAndExec() {
    local cmd="$1"
    if is_dry_run; then
        echo "[dry-run] ${cmd}"
    else
        eval "${cmd}"
    fi
}

# Evaluate `brew shellenv` for a given brew binary, or print it in dry-run mode.
function run_brew_shellenv() {
    local brew_cmd="$1"
    logAndExec "eval \"\$(${brew_cmd} shellenv)\""
}

function get_os_type() {
    uname
}

function keepalive_sudo_linux() {
    # Might as well ask for password up-front, right?
    echo "Checking for \`sudo\` access which may request your password."
    sudo -v

    # Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2> /dev/null &
}

function keepalive_sudo_macos() {
    # ref. https://github.com/reitermarkus/dotfiles/blob/master/.sh#L85-L116
    (
        builtin read -r -s -p "Password: " < /dev/tty
        builtin echo "add-generic-password -U -s 'dotfiles' -a '${USER}' -w '${REPLY}'"
    ) | /usr/bin/security -i
    printf "\n"
    at_exit "
                echo -e '\033[0;31mRemoving password from Keychain …\033[0m'
                /usr/bin/security delete-generic-password -s 'dotfiles' -a '${USER}'
            "
    SUDO_ASKPASS="$(/usr/bin/mktemp)"
    at_exit "
                echo -e '\033[0;31mDeleting SUDO_ASKPASS script …\033[0m'
                /bin/rm -f '${SUDO_ASKPASS}'
            "
    {
        echo "#!/bin/sh"
        echo "/usr/bin/security find-generic-password -s 'dotfiles' -a '${USER}' -w"
    } > "${SUDO_ASKPASS}"

    /bin/chmod +x "${SUDO_ASKPASS}"
    export SUDO_ASKPASS

    if ! /usr/bin/sudo -A -kv 2> /dev/null; then
        echo -e '\033[0;31mIncorrect password.\033[0m' 1>&2
        exit 1
    fi
}

function keepalive_sudo() {
    if is_user_mode; then
        echo "Skipping sudo keep-alive (user mode)."
        return 0
    fi

    if is_dry_run; then
        echo "[dry-run] Would keep sudo alive (sudo -v / Keychain password prompt)."
        return 0
    fi

    local ostype
    ostype="$(get_os_type)"

    if [ "${ostype}" == "Darwin" ]; then
        keepalive_sudo_macos
    elif [ "${ostype}" == "Linux" ]; then
        keepalive_sudo_linux
    else
        echo "Invalid OS type: ${ostype}" >&2
        exit 1
    fi
}

function initialize_homebrew_user() {
    local brew_prefix="${HOME}/.homebrew"
    local brew_bin="${brew_prefix}/bin/brew"

    if [[ ! -x "${brew_bin}" ]]; then
        echo "Installing Homebrew to ${brew_prefix} (user space, no sudo required)..."
        run mkdir -p "${brew_prefix}"
        run git clone https://github.com/Homebrew/brew "${brew_prefix}/Homebrew"
        run mkdir -p "${brew_prefix}/bin"
        run ln -sfn ../Homebrew/bin/brew "${brew_prefix}/bin/brew"
    else
        echo "Homebrew already installed at ${brew_prefix}."
    fi

    run_brew_shellenv "${brew_bin}"
    run brew update --force --quiet || echo "Warning: 'brew update' failed; continuing with existing installation." >&2
}

function initialize_os_macos() {
    function is_homebrew_exists() {
        command -v brew &> /dev/null
    }

    if is_user_mode; then
        initialize_homebrew_user
        return 0
    fi

    # Instal Homebrew if needed.
    if ! is_homebrew_exists; then
        logAndExec '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    fi

    # Setup Homebrew envvars.
    if [[ $(arch) == "arm64" ]]; then
        run_brew_shellenv /opt/homebrew/bin/brew
    elif [[ $(arch) == "i386" ]]; then
        run_brew_shellenv /usr/local/bin/brew
    else
        echo "Invalid CPU arch: $(arch)" >&2
        exit 1
    fi
}

function initialize_os_linux() {
    :
}

function initialize_os_env() {
    local ostype
    ostype="$(get_os_type)"

    if [ "${ostype}" == "Darwin" ]; then
        initialize_os_macos
    elif [ "${ostype}" == "Linux" ]; then
        initialize_os_linux
    else
        echo "Invalid OS type: ${ostype}" >&2
        exit 1
    fi
}

function run_chezmoi() {
    local bin_dir="${HOME}/.local/bin"
    export PATH="${PATH}:${bin_dir}"

    # download the chezmoi binary from the URL
    logAndExec "sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- -b \"${bin_dir}\""
    local chezmoi_cmd="${bin_dir}/chezmoi"

    if is_ci_or_not_tty; then
        no_tty_option="--no-tty" # /dev/tty is not available (especially in the CI)
    else
        no_tty_option="" # /dev/tty is available OR not in the CI
    fi
    # run `chezmoi init` to setup the source directory,
    # generate the config file, and optionally update the destination directory
    # to match the target state.
    run "${chezmoi_cmd}" init "${DOTFILES_REPO_URL}" \
        --force \
        --branch "${BRANCH_NAME}" \
        --use-builtin-git true \
        ${no_tty_option}

    # the `age` command requires a tty, but there is no tty in the github actions.
    # Therefore, it is currnetly difficult to decrypt the files encrypted with `age` in this workflow.
    # I decided to temporarily remove the encrypted target files from chezmoi's control.
    if is_ci_or_not_tty; then
        logAndExec "find \"\$(${chezmoi_cmd} source-path)\" -type f -name \"encrypted_*\" -exec rm -fv {} +"
    fi

    # Add to PATH for installing the necessary binary files under `$HOME/.local/bin`.
    export PATH="${PATH}:${HOME}/.local/bin"

    # run `chezmoi apply` to ensure that target... are in the target state,
    # updating them if necessary.
    run "${chezmoi_cmd}" apply ${no_tty_option}

    # purge the binary of the chezmoi cmd
    run rm -fv "${chezmoi_cmd}"
}

function initialize_dotfiles() {

    if ! is_ci_or_not_tty; then
        # - /dev/tty of the github workflow is not available.
        # - We can use password-less sudo in the github workflow.
        # Therefore, skip the sudo keep alive function.
        keepalive_sudo
    fi
    run_chezmoi
}

function get_system_from_chezmoi() {
    local system
    system=$(chezmoi data | jq -r '.system')
    echo "${system}"
}

function restart_shell_system() {
    local system
    system=$(get_system_from_chezmoi)

    # exec shell as login shell (to reload the .zprofile or .profile)
    if [ "${system}" == "client" ]; then
        /bin/zsh --login

    elif [ "${system}" == "server" ]; then
        /bin/bash --login

    else
        echo "Invalid system: ${system}; expected \`client\` or \`server\`" >&2
        exit 1
    fi
}

function restart_shell() {

    # Restart shell if specified "bash -c $(curl -L {URL})"
    # not restart:
    #   curl -L {URL} | bash
    if [ -p /dev/stdin ]; then
        echo "Now continue with Rebooting your shell"
    else
        echo "Restarting your shell..."
        restart_shell_system
    fi
}

function main() {
    echo "${DOTFILES_LOGO}"

    parse_args "$@"
    validate_mode

    # Make the chosen mode available to chezmoi's config template so it is
    # persisted into the chezmoi data as `mode`.
    export DOTFILES_MODE="${MODE}"

    echo "Running in ${MODE} mode."
    if is_dry_run; then
        echo "DRY RUN: Showing what would be done without executing anything."
    fi

    initialize_os_env
    initialize_dotfiles

    # restart_shell # Disabled because the at_exit function does not work properly.
}

main "$@"
