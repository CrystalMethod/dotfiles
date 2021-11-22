#!/usr/bin/env sh

if command -v kubectl krew >/dev/null 2>&1; then
    kubectl krew install mtail
    kubectl krew install np-viewer
    kubectl krew install get-all
    kubectl krew install kubesec-scan
    kubectl krew install images
    kubectl krew install df-pv
    kubectl krew install ns
    kubectl krew install ctx
    kubectl krew install konfig
    kubectl krew install sniff
    kubectl krew install tail
    kubectl krew install tree
else
    ./run_once_install-krew.sh
fi

