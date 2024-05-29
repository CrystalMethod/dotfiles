## PATH && ENV variables

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Aqua
export AQUA_ROOT_DIR=${XDG_DATA_HOME}/aquaproj-aqua
export AQUA_GLOBAL_CONFIG=${XDG_CONFIG_HOME}/aqua/aqua.yaml
export AQUA_POLICY_CONFIG=${XDG_CONFIG_HOME}/aqua/aqua-policy.yaml
export PATH="$AQUA_ROOT_DIR/bin:$PATH"

export DOTFILES=$HOME/.local/share/chezmoi
export REPOS=$HOME/repos
export GHQ_ROOT=$REPOS

export NVIM_APPNAME=LazyVim
export COLEMAK=true

# vim:ft=zsh:nowrap
