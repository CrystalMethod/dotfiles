#!/usr/bin/env sh

if  command -v skaffold >/dev/null 2>&1; then
    echo "Skaffold CLI already installed"
else
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
        sudo install skaffold /usr/local/bin/
fi
