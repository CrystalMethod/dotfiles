#!/usr/bin/env zsh

eval "$(fnm env)"

FNM_USING_LOCAL=0
load-nvrmrc() {
  if [[ -r .nvmrc || -r .node-version ]]; then
    FNM_USING_LOCAL=1
    fnm use
  elif [ $FNM_USING_LOCAL -eq 1 ]; then
    FNM_USING_LOCAL=0
    fnm use default
  fi
}

load-nvrmrc

autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvrmrc
