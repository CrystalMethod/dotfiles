#!/usr/bin/env sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! xcode-select --print-path > /dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install &> /dev/null
    # wait until the Xcode Command Line Tools are installed
    until xcode-select --print-path > /dev/null 2>&1; do
      sleep 5
    done
  fi
fi

set -e # -e: exit on error

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsLS https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you need curl or wget installed" >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

# exec: replace the current process with the given command
exec "$chezmoi" init --apply CrystalMethod --keep-going
