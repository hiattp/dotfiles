# Dotfiles

Personal macOS configuration layered over [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles), installed with [rcm](https://github.com/thoughtbot/rcm). Neovim is the default terminal and Git editor.

## Install on a new Mac

Install Homebrew, Git, and rcm, then clone the public configuration and thoughtbot defaults:

```sh
git clone https://github.com/thoughtbot/dotfiles.git ~/.thoughtbot-dotfiles
git clone https://github.com/hiattp/dotfiles.git ~/.hiattp-dotfiles
```

For a work machine, authenticate GitHub and also clone the optional private companion:

```sh
git clone git@github.com:hiattp/dotfiles-private.git ~/.hiattp-dotfiles-private
```

Preview and install the symlinks:

```sh
env RCRC="$HOME/.hiattp-dotfiles/rcrc" lsrc
env RCRC="$HOME/.hiattp-dotfiles/rcrc" rcup -K
```

Use `rcup -K` to skip the thoughtbot post-install hook, which still tries to install and update Vim plugins. Review any existing-file conflicts before replacing them. `rcrc` combines the private companion, public configuration, and thoughtbot defaults, in that order. Documentation, migration archives, tests, local Claude settings, optional tools, and legacy Vim configuration are excluded from installation. Executables in `bin` are linked into `~/bin`.

Use the [thoughtbot laptop script](https://github.com/thoughtbot/laptop) for the remaining machine setup. It sources `~/.laptop.local`, which is installed above. Review its base package list too: it may still install Vim independently of this configuration.

```sh
curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
less mac
sh mac 2>&1 | tee ~/laptop.log
```

`laptop.local` is the maintained Homebrew install list. It includes Neovim, fzf, ripgrep, Git/GitHub CLI, Git LFS, rcm, asdf, Kerberos, cloud and Kubernetes tools, document utilities, and desktop applications. Optional work packages come from `~/.laptop.private` in the companion repository. Runtime versions remain in `tool-versions`; review those pins before installing on a new OS.

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

The Lua configuration lives in `config/nvim`. Start `nvim` after installation; lazy.nvim installs plugins. Use `:Lazy restore` to restore the versions recorded in `lazy-lock.json`, then `:checkhealth` to inspect external dependencies. Updates are checked but no longer applied automatically at startup.

The Claude Code and Splitwise plugins use local checkouts at `~/repos/claude-code.nvim` and `~/repos/splitwise.nvim` when those directories exist; otherwise lazy.nvim fetches them from GitHub. The companion's migration notes preserve local Claude Code changes from the previous machine. Copilot's configuration is retained but disabled.

Install MesloLG Nerd Font and select it in iTerm2. Ruby language support expects `ruby-lsp` in the active asdf Ruby environment (`gem install ruby-lsp`). Project formatters such as RuboCop, erb_lint, and Prettier should be installed with each project's dependencies. The old Vim/MacVim configuration and Python-provider instructions have been retired; Vimscript plugins used by Neovim are retained.

For the standalone `sonarjs` helper, install its saved dependencies once:

```sh
cd ~/.local/lint-tools
pnpm install --frozen-lockfile
```

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

Import `iterm_profile.json` in iTerm2. In Karabiner Elements, enable the Escape Multifunction rule and set `to_if_alone_timeout_milliseconds` to 500; map Caps Lock to Escape if desired. Other application preferences and authentication should be reviewed on the new machine.
