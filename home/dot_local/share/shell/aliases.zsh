#!/usr/bin/env zsh

alias kctx="konf set"
alias kns="konf namespace"
alias cd="z"
alias cat="bat"

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"

command -v kubecolor &>/dev/null && alias kubectl='kubecolor'
