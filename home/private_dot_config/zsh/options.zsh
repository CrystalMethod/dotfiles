## ZSH options

umask 022
zmodload zsh/zle
zmodload zsh/zpty
zmodload zsh/complist

autoload -Uz colors && colors
autoload -Uz compinit && compinit -i

# completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# history
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase

while read -r opt
do
  setopt $opt
done <<-EOF
AUTOCD
AUTO_MENU
AUTO_PARAM_SLASH
COMPLETE_IN_WORD
NO_MENU_COMPLETE
HASH_LIST_ALL
ALWAYS_TO_END
NOTIFY
NOHUP
MAILWARN
INTERACTIVE_COMMENTS
NOBEEP
APPEND_HISTORY
SHARE_HISTORY
INC_APPEND_HISTORY
EXTENDED_HISTORY
HIST_IGNORE_ALL_DUPS
HIST_IGNORE_SPACE
HIST_NO_FUNCTIONS
HIST_EXPIRE_DUPS_FIRST
HIST_SAVE_NO_DUPS
HIST_REDUCE_BLANKS
EOF

while read -r opt
do
  unsetopt $opt
done <<-EOF
FLOWCONTROL
NOMATCH
CORRECT
EQUALS
EOF

export FZF_DEFAULT_OPTS="
--ansi
--layout=default
--info=inline
--color 16
--height=50%
--multi
--preview-window=right:50%
--preview-window=sharp
--preview-window=cycle
--preview '([[ -f {} ]] && (bat --style=numbers --color=always --line-range :500 {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--prompt='λ -> '
--pointer='▷'
--marker='✓'"
# --bind 'ctrl-e:execute(nvim {} < /dev/tty > /dev/tty 2>&1)' > selected
# --bind 'ctrl-v:execute(code {+})'"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# vim:filetype=zsh:nowrap
