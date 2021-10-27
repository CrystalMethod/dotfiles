# general exports
export EDITOR=$HOME/.bin/editor
export VISUAL=$HOME/.bin/editor
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export LESS='-F -g -i -M -R -S -w -X -z-4'

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

if [[ ${OSTYPE} == darwin* ]]; then
	export HOMEBREW_NO_AUTO_UPDATE=1
	export HOMEBREW_VERBOSE_USING_DOTS=1
	# fzf
	source /usr/local/opt/fzf/shell/key-bindings.zsh
	source /usr/local/opt/fzf/shell/completion.zsh
else
	# fzf
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh
fi

export PATH="$HOME/.bin:$PATH"

### Plugins

# Go path
export GOPATH=$HOME/workspace/go
export PATH=$GOPATH/bin:$PATH

## Tmux
# autostart tmux
# from: https://github.com/zpm-zsh/tmux/blob/master/tmux.plugin.zsh

# Make sure we are not sshing to this shell or running within an i3 session
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$I3SOCK" ]; then
	export TMUX_AUTOSTART="false"
else
	export TMUX_AUTOSTART="true"
fi

if [ -f "$HOME/.env-secrets" ]; then
	source "$HOME/.env-secrets"
fi

# FZF
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'

export GITLINE_REPO_INDICATOR='${reset}ᚴ'
export GITLINE_BRANCH='[${blue}${branch}${reset}]'

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
