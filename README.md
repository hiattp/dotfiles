My Local Setup
==============

My setup is based on the rock solid [thoughtbot dotfiles](https://github.com/thoughtbot/dotfiles) (and [rcm](https://github.com/thoughtbot/rcm)).

These are just local overrides that suit my workflows.

## Dotfile Installation

The following commands add the `~/.hiattp-dotfiles` and  `~/.thoughtbot-dotfiles` directories, then uses rcm to symlink the dotfiles into the home directory. Note that some things won't work unless you are running Zsh instead of Bash, and you must have [rcm](https://github.com/thoughtbot/rcm) installed.

```
git clone https://github.com/thoughtbot/dotfiles.git ~/.thoughtbot-dotfiles
git clone https://github.com/hiattp/dotfiles.git ~/.hiattp-dotfiles
env RCRC=$HOME/.hiattp-dotfiles/rcrc rcup
```

## MacVim

On OSX I prefer and recommend [MacVim](https://github.com/b4winckler/macvim/releases) as the default editor, since it has the perks of a traditional OSX application.

## Zsh Setup

First, set the shell to use Zsh by default:

    chsh -s /bin/zsh

I like having the [Oh My Zsh!](https://github.com/robbyrussell/oh-my-zsh) plugins/settings readily available. Either comment out the OMZ settings in `zshrc.local` or install it with:

    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

Then restart the shell and enjoy!
