#!/usr/bin/env sh

if  command -v kubectl krew >/dev/null 2>&1; then 
    echo "Krew Plugin Manager already installed"
else
  curl https://krew.sh/ | bash
fi
