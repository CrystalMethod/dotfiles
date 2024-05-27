## plugins

ZINIT_HOME="${ZINIT_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zinit}"

# Added by Zinit's installer
if [[ ! -f ${ZINIT_HOME}/zinit.git/zinit.zsh ]]; then
    print -P "%F{14}▓▒░ Installing Flexible and fast ZSH plugin manager %F{13}(zinit)%f"
    command mkdir -p "${ZINIT_HOME}" && command chmod g-rwX "${ZINIT_HOME}"
    command git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}/zinit.git" && \
        print -P "%F{10}▓▒░ Installation successful.%f%b" || \
        print -P "%F{9}▓▒░ The clone has failed.%f%b"
fi

source "${ZINIT_HOME}/zinit.git/zinit.zsh"

zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit light-mode for \
  hlissner/zsh-autopair \
  zdharma-continuum/fast-syntax-highlighting \
  MichaelAquilina/zsh-you-should-use \
  zsh-users/zsh-autosuggestions

zinit wait"2" lucid light-mode for \
  wfxr/forgit \
  has'fzf' Aloxaf/fzf-tab \
  OMZP::command-not-found \
  OMZP::fancy-ctrl-z \
  OMZP::gh \
  OMZP::helm \
  OMZP::kubectl \
  OMZP::mise \
  joshskidmore/zsh-fzf-history-search

command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v fzf &>/dev/null && eval "$(fzf --zsh)"

zinit cdreplay -q

# vim:ft=zsh
