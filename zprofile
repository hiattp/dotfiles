# macOS path_helper runs before this file and can put Homebrew before asdf.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

source "$HOME/.config/hiattp/shell-path.zsh"
