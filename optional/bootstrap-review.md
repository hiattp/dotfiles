# Bootstrap review and preflight

Reviewed 2026-10-23. This is a source and compatibility review of the setup route, not a certification that every upstream account, package, installer, or downloaded application is uncompromised.

## Reviewed snapshots

| Source | Revision or checksum |
| --- | --- |
| [thoughtbot/laptop](https://github.com/thoughtbot/laptop/tree/6723ed10d3be551004b8abd95815ef3fd844c56c) | `6723ed10d3be551004b8abd95815ef3fd844c56c` (2026-08-13 release) |
| Laptop `mac` SHA-256 | `6099a557e8ff415da97690a3f7babb7cf94370206fb9cbacfbf2e2bab9bbc642` |
| [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles/tree/939a27005b2dd4ac1556e104fc91122f3aea0a6c) | `939a27005b2dd4ac1556e104fc91122f3aea0a6c` |

The laptop release and recent 2026 script changes show GitHub-verified signatures. The defaults snapshot is unsigned. A verified signature is evidence about the recorded commit, not proof that the author's account or dependencies are safe. Direct downloads of the requested `/master/mac` URL and the pinned laptop commit matched byte-for-byte during this review. GitHub's maintained branch is `main`; avoid relying on the old branch name or cached search results.

The reviewed laptop script has no obvious credential harvesting, unexplained outbound destinations, obfuscated payloads, or commands disabling Gatekeeper/SIP. Its source matches its stated workstation setup purpose. Its recent changes update Homebrew/asdf compatibility, Bundler syntax, Heroku trust, and PostgreSQL selection. It does execute a substantial dependency chain, so source review of this small script alone cannot establish the safety of everything installed.

## Effects and privileges

- Creates `~/.bin` and appends shell initialization to the local Zsh configuration.
- Uses `sudo` to add a shell to `/etc/shells` if needed and to change the login shell. It can install Rosetta through Apple's `softwareupdate` on Apple Silicon.
- Can download and run Homebrew's installer if Homebrew is absent. The documented route installs Homebrew first, avoiding this nested bootstrap step.
- Updates Homebrew and installs formulae/casks, including software from third-party vendors. Individual applications/installers can request additional macOS privileges.
- Explicitly trusts the Heroku formula. It also installs Vim and enables PostgreSQL 18 and Redis services. These are intentional upstream defaults, not required by Neovim.
- Installs current Ruby/Node via asdf and modifies home-level runtime selections before sourcing `~/.laptop.local`.

The public laptop customization selects Node LTS as its final Node default, current stable Ruby/Terraform, and current stable Homebrew Python/Go/Rust/.NET packages. It does not install the archived global runtime pins. It stops on failed piped downloads, and does not pull into the existing reviewed dotfile checkouts.

## Package-list corrections from this review

ZAP was removed at the user's request. At review time, its Homebrew cask was disabled because it failed Gatekeeper checks. No quarantine or Gatekeeper bypass was added. Homebrew's [security documentation](https://docs.brew.sh/Homebrew-Security-and-Supply-Chain) explains its distribution baseline.

The install list now uses Azure CLI and 1Password CLI as casks, `tailscale-app` for Tailscale, and `sdl2-compat` for SDL2 compatibility. Current official metadata was checked for the public package list. Vendor recipes for Azure Functions, Ookla Speedtest, Flux, and Microsoft's SQL tools/ODBC driver were inspected for their source domains, checksums, installation commands, and dependencies; their downloaded binaries were not audited.

Third-party trust is limited to specific packages, following [Homebrew's tap-trust guidance](https://docs.brew.sh/Tap-Trust): Azure Functions, Ookla Speedtest, and Flux in the public list; Microsoft's SQL tools and ODBC driver in the private list. Whole taps are not trusted by these customizations. The upstream base script separately trusts Heroku. Formula trust permits that recipe's Ruby code to execute as your user; it is not a sandbox. No trust settings on the old computer were changed by this review.

The old .NET asdf plugin had not been updated since 2023; fresh installs use the maintained Homebrew .NET package instead. The same route uses Homebrew for Python, Go, and Rust. asdf remains available for project-specific version management. The old global Ruby 3.1, Node 23, Python 3.9, and .NET 6 selections are not carried into new installs.

## Before retiring the old computer

1. Finish OS updates, company enrollment, FileVault configuration, and recovery-key storage on the new Mac. Use your ordinary account for the installer; review its explicit elevation prompts and application permissions.
2. Preserve SSH/signing keys and `allowed_signers` through your secure transfer process. The private dotfiles contain key paths and SSH settings, not the keys. Reauthenticate GitHub, Claude, Codex, cloud CLIs, VPN, and Kerberos.
3. Back up any local databases and unpushed/ignored work files. This setup does not migrate databases or working repositories. PostgreSQL major versions need a supported upgrade or dump/restore path; do not copy an old PostgreSQL data directory directly into PostgreSQL 18.
4. Preview `lsrc` and use `rcup -K`. If an earlier run linked `~/.tool-versions` to the old reference file, the README's bootstrap block moves that link aside before the upstream script writes new defaults.
5. Review desktop apps that can request system extensions or broad permissions, especially Docker, Parallels, VPN/security tools, and Karabiner. The package list is executable installation scope, not merely an inventory.
6. After installation, start a new terminal, run `brew doctor`, `asdf current`, `claude --version`, `codex --version`, and Neovim `:checkhealth`. Verify Git identity and signing before the first commit, and follow the private agent-template restore notes.

Validation performed here: exact-source checksum comparison, upstream commit/history inspection, ShellCheck, a temporary-home rcm installation, command-stub tests of `laptop.local`, runtime-selection tests, package metadata checks, and existing Neovim/shell-helper checks. No actual full fresh-Mac installation was performed on this computer.
