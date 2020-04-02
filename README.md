These dotfiles are based on the [thoughtbot dotfiles](https://github.com/thoughtbot/dotfiles) (and [rcm](https://github.com/thoughtbot/rcm)), and are largely just overrides against thoughtbot's defaults based on
personal preference.

## Dotfile Installation

The following adds the `~/.hiattp-dotfiles` and  `~/.thoughtbot-dotfiles` directories, then uses rcm to symlink the dotfiles into the home directory. Note that some things won't work unless you are running Zsh instead of Bash, and you must have [rcm](https://github.com/thoughtbot/rcm) installed.

```
git clone git@github.com:thoughtbot/dotfiles.git ~/.thoughtbot-dotfiles
git clone git@github.com:hiattp/dotfiles.git ~/.hiattp-dotfiles
env RCRC=$HOME/.hiattp-dotfiles/rcrc rcup
```

## New System Setup

Run thoughtbot's [laptop script](https://github.com/thoughtbot/laptop) on new
machines to get things started. As of this writing Python isn't installed by
that script, so get the latest:

    brew install python

If needed, install the AWS CLI with `pip install awscli && aws configure` and
a PGP implementation with `brew install gnupg gnupg2`.

## MacVim and iTerm2

There are good terminal emulators out there but my current favorite is
[iTerm2](https://www.iterm2.com/), if for no other reason than the ease of
rendering spec failure screenshots inline.

[MacVim](https://github.com/b4winckler/macvim/releases) is my editor of choice
since it has the perks of a traditional OSX application combined with the power
of Vim.

## Zsh Setup

Set the shell to use Zsh by default:

    chsh -s /bin/zsh

Install [Oh My Zsh!](https://github.com/robbyrussell/oh-my-zsh) to take
advantage of the handy plugins (`zshrc.local` anticipates OMZ being installed).

## Other Notes:

The flavor du jour of runtime version managers (as far as these dotfiles are
concerned) is [asdf-vm](https://asdf-vm.com/). You'll want to follow install
instructions there if you didn't pull it in via the laptop script above,
or remove `asdf` references in such places as `zshrc.local`.

If you use Heroku you might want to use
[heroku accounts](https://github.com/heroku/heroku-accounts) and
[heroku-binstubs](https://github.com/tpope/heroku-binstubs).

If you use ctags in ruby environments,
[this](https://github.com/tpope/gem-ctags) is helpful.
