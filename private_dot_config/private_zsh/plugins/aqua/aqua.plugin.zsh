export AQUA_ROOT_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/aqua
export AQUA_GLOBAL_CONFIG=${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua.yaml
export PATH=${AQUA_ROOT_DIR}/bin:$PATH

