# Shared by login shells (including agents) and interactive shells.
# Keep native/pipx CLIs ahead of stale asdf shims, and pinned runtimes ahead of brew.
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
  "$HOME/bin"
  "$HOME/.bin"
  $path
  "$HOME/.docker/bin"
  "$HOME/repos/go_repos/bin"
)
export PATH
