# Dotfiles

Personal macOS configuration layered over [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles), installed with [rcm](https://github.com/thoughtbot/rcm). Neovim is the default terminal and Git editor.

## Install on a new Mac

Complete macOS updates and your required work-device enrollment first. Install Apple's Command Line Tools (`xcode-select --install`), then install [Homebrew using its official instructions](https://brew.sh). Run this setup as your regular user, rather than running the whole script with `sudo`.

```sh
brew install git gh rcm
git clone https://github.com/thoughtbot/dotfiles.git ~/.thoughtbot-dotfiles
git -C ~/.thoughtbot-dotfiles checkout --detach 939a27005b2dd4ac1556e104fc91122f3aea0a6c
git clone https://github.com/hiattp/dotfiles.git ~/.hiattp-dotfiles
```

The thoughtbot defaults are pinned to the snapshot checked with this setup. Review upstream changes before choosing a newer commit. For a work machine, authenticate GitHub over HTTPS and clone the private companion before installing its SSH settings. This avoids requiring your SSH keys just to obtain the private configuration:

```sh
gh auth login --hostname github.com --git-protocol https --web
git clone https://github.com/hiattp/dotfiles-private.git ~/.hiattp-dotfiles-private
```

Preview and install the symlinks:

```sh
env RCRC="$HOME/.hiattp-dotfiles/rcrc" lsrc
env RCRC="$HOME/.hiattp-dotfiles/rcrc" rcup -K
```

Use `rcup -K` to skip the thoughtbot post-install hook, which still tries to install and update Vim plugins. Review existing-file conflicts before replacing them. `rcrc` combines the private companion, public configuration, and thoughtbot defaults, in that order. Documentation, migration archives, tests, local Claude settings, optional tools, legacy Vim configuration, and the old global runtime pins are excluded. Executables in `bin` are linked into `~/bin`.

The [thoughtbot laptop script](https://github.com/thoughtbot/laptop) runs `~/.laptop.local` for the remaining setup. Download the exact script reviewed on 2026-10-23 and verify its SHA-256 before running it. The subshell stops on download/checksum errors and preserves the installer's failure status while logging:

```sh
(
  set -e
  set -o pipefail
  setup_file="$HOME/laptop-mac-reviewed"
  curl -fsSL https://raw.githubusercontent.com/thoughtbot/laptop/6723ed10d3be551004b8abd95815ef3fd844c56c/mac -o "$setup_file"
  printf '%s  %s\n' 6099a557e8ff415da97690a3f7babb7cf94370206fb9cbacfbf2e2bab9bbc642 "$setup_file" | shasum -a 256 -c -
  less "$setup_file"
  # Detach a symlink left by an earlier version of these setup instructions.
  # The old repository file is retained as a reference.
  if [ -L "$HOME/.tool-versions" ] && [ "$HOME/.tool-versions" -ef "$HOME/.hiattp-dotfiles/tool-versions" ]; then
    mv -i "$HOME/.tool-versions" "$HOME/.tool-versions.legacy-$(date +%Y%m%d%H%M%S)"
  fi
  bash "$setup_file" 2>&1 | tee "$HOME/laptop.log"
)
```

See the [bootstrap review and preflight notes](optional/bootstrap-review.md) for the script's permissions, dependency chain, and known side effects. In particular, the base script also installs Vim, Heroku, PostgreSQL 18, and Redis, and starts the database services. Review those choices before executing it. The checksum pins this script; Homebrew packages, runtime installers, Claude's native installer, and the globally installed Playwright npm package remain separate upstream dependencies.

`laptop.local` is the maintained package list. It includes Neovim, fzf, ripgrep, Git/GitHub CLI, Git LFS, rcm, asdf, Kerberos, cloud and Kubernetes tools, document utilities, and desktop applications. Codex is a Homebrew cask and Claude Code uses its native installer. Optional work packages come from `~/.laptop.private` in the companion repository. Existing dotfile checkouts are reused without pulling changes during installation.

New installs select current stable Ruby and Terraform through asdf, and Node's latest LTS release. Python, Go, Rust, and .NET use Homebrew's current stable packages. The checked-in `tool-versions` is historical reference only and is not installed or used to choose defaults. The selected asdf versions are recorded in the new machine's regular `~/.tool-versions`; individual projects can continue to pin their own versions. Read the private companion's migration checklist before retiring the old machine.

## Public and private settings

The public repo supplies personal defaults. The private companion supplies optional files:

| File | Purpose |
| --- | --- |
| `gitconfig.private` | Git identity, SSH/signing paths, and work overrides |
| `aliases.private` | Work aliases |
| `zshrc.private` | Machine/work paths and environment variables |
| `laptop.private` | Additional work software |
| `zsh/functions/*` | Work-specific shell helpers |

Git includes `~/.gitconfig.private` last, and Zsh loads the private shell files when present. Without the companion, the public configuration uses the personal Git identity and does not require a particular SSH key or signing setup. Store credentials and private keys in the appropriate credential store, outside both repositories.

## Neovim

The Lua configuration lives in `config/nvim`. Start `nvim` after installation; lazy.nvim installs plugins. Use `:Lazy restore` to restore the versions recorded in `lazy-lock.json`, then `:checkhealth` to inspect external dependencies. Plugin update checks run silently every 30 days, with startup update notifications disabled. Open `:Lazy` to inspect available updates and use `:Lazy update` when ready to apply them.

The Claude Code and Splitwise plugins use local checkouts at `~/repos/claude-code.nvim` and `~/repos/splitwise.nvim` when those directories exist; otherwise lazy.nvim fetches them from GitHub. The companion's migration notes preserve local Claude Code changes from the previous machine. Copilot's configuration is retained but disabled.

Install MesloLG Nerd Font and select it in iTerm2. Ruby language support expects `ruby-lsp` in the active asdf Ruby environment (`gem install ruby-lsp`). Project formatters such as RuboCop, erb_lint, and Prettier should be installed with each project's dependencies. The old Vim/MacVim configuration and Python-provider instructions have been retired; Vimscript plugins used by Neovim are retained.

## Kerberos

The install list explicitly includes [`krb5`](https://formulae.brew.sh/formula/krb5), which supplies `kinit`, `klist`, and `kdestroy`. Homebrew keeps it keg-only because macOS also supplies Kerberos. Plain `kinit` can therefore still select Apple's version, as it did on the previous machine. To use MIT Kerberos explicitly:

```sh
"$(brew --prefix krb5)/bin/kinit" your-principal
```

If MIT Kerberos should be the default on a work machine, add its `bin` directory to PATH in `zshrc.private`. Restore realm configuration separately as described in the companion; obtain fresh tickets on the new machine.

## Codex and resource checks

`codex-isolated` launches `codex --no-daemon` and raises the session's soft file-descriptor limit to at least 1024 without changing the calling shell's limits. Set `CODEX_ISOLATED_NOFILE_LIMIT` to choose another minimum within the OS hard limit. Arguments are forwarded unchanged:

```sh
codex-isolated
codex-isolated resume
```

The optional `codex-resource-monitor` reports file descriptors, descendant processes, memory, and the system kernel file table. These checks concern resources other than disk space. It sends notifications only when explicitly invoked with `--check` or enabled as a LaunchAgent; it never kills or restarts sessions.

```sh
codex-resource-monitor --status
codex-resource-monitor --self-test
```

The LaunchAgent is excluded from normal `rcup` installation. To enable periodic checks on a particular Mac:

```sh
mkdir -p ~/Library/LaunchAgents
cp ~/.hiattp-dotfiles/optional/launchd/com.hiattp.codex-resource-monitor.plist ~/Library/LaunchAgents/
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.hiattp.codex-resource-monitor.plist
```

Disable with `launchctl bootout "gui/$(id -u)/com.hiattp.codex-resource-monitor"`. Isolation works without the monitor; when available, the launcher records its actual descriptor limit for status reporting.

## Worktrees

`gwa` wraps `git worktree add`. It creates an ordinary worktree by default; `--cow` copies ignored files and paths listed in `.cow-include` using APFS copy-on-write, with a regular-copy fallback. Existing destination paths are preserved unless `--cow-force` is given. Copying remains explicit to avoid bringing credentials, dependencies, or generated files into a checkout unintentionally.

```sh
gwa -b feature ../project-feature
gwa --cow -b feature ../project-feature
```

There is no fixed worktree-count or free-space limit in this configuration. When cleaning up worktrees, retain the correctness checks: remove only clean, unlocked, inactive worktrees whose commits are proven merged; use `git worktree remove` without force, and preserve branches and session history.

## Application settings

The laptop setup installs [Playwright's browser CLI for coding agents](https://playwright.dev/docs/getting-started-cli) globally with `npm install --global @playwright/cli@latest`, after selecting Node LTS. Its command is `playwright-cli`; verify it with `playwright-cli --help`. This CLI works independently of the older Playwright MCP development checkout recorded in the private migration templates.

For a shared Claude Code skill across projects, optionally run `playwright-cli install --skills -g`. The CLI also works through its own help and commands without installing that skill.

Import `iterm_profile.json` in iTerm2. In Karabiner Elements, enable the Escape Multifunction rule and set `to_if_alone_timeout_milliseconds` to 500; map Caps Lock to Escape if desired. Other application preferences and authentication should be reviewed on the new machine.
