#!/usr/bin/env sh

cat <<EOF|tic -x -
tmux|tmux terminal multiplexer,
    ritm=\E[23m, rmso=\E[27m, sitm=\E[3m, smso=\E[7m, Ms@,
    use=xterm+tmux, use=screen,

tmux-256color|tmux with 256 colors,
    use=xterm+256setaf, use=tmux,

xterm-256color-italic|xterm with 256 colors and italic,
    sitm=\E[3m, ritm=\E[23m,
    use=xterm-256color,
EOF
