These dotfiles are based on the [thoughtbot dotfiles](https://github.com/thoughtbot/dotfiles) (and [rcm](https://github.com/thoughtbot/rcm)), and are largely just overrides against thoughtbot's defaults based on
personal preference.

## New System Setup

Use the [thoughtbot laptop script](https://github.com/thoughtbot/laptop) to set
up a new machine. The `laptop.local` script here will install the following (not
included in the thoughtbot script by default):

1. MacVim
1. [Overmind](https://github.com/DarthSim/overmind)
1. Python (with Pip)
1. vips (image processing)
1. iTerm2
1. Google Chrome
1. Karabiner Elements
1. Dropbox
1. 1Password
1. Karabiner Elements
1. GitHub
1. Divvy
1. Microsoft Teams, Excel, Word and Powerpoint

```
curl https://raw.githubusercontent.com/hiattp/dotfiles/master/laptop.local > ~/.laptop.local
curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log
```

NOTE: You'll want to adjust a few settings/parameters in the applications that
were installed:

1. In Karabiner Elements, go to "Complex modifications" and "Add rule" to find
   the Escape Multifunction behavior and enable it. Then choose "Parameters" and
   change `to_if_alone_timeout_milliseconds` to 500.
1. In Karabiner Elements, map Caps Lock to Escape as a "Simple modification".
1. In OSX change the cursor speed and key repeat speed to highest, and
   delay until key repeat to lowest in the Mouse and Keyboard settings
   respectively.
1. In OSX enable Accessibility > Track Pad > Click Lock Drag.
1. In OSX Screensaver > Hot Corners set the bottom right to "Desktop".
1. In OSX check Trackpad > Tap to click and Tracking Speed to Fast.
1. In Chrome uncheck Chrome > Warn Before Quitting.
1. Configure/Setup Dropbox
1. Configure/Setup 1Password
1. Go to iTerm2 > Preferences > Profiles and click Other Actions > Import JSON
   Profiles, importing `iterm_profile.json`.
1. Speed up the mouse scaling with `defaults write -g com.apple.mouse.scaling  12.0`.
   A restart is needed for this to take effect.

## Dotfile Installation on Existing Systems

The following adds the `~/.hiattp-dotfiles` and  `~/.thoughtbot-dotfiles` directories, then uses rcm to symlink the dotfiles into the home directory. Note that some things won't work unless you are running Zsh instead of Bash, and you must have [rcm](https://github.com/thoughtbot/rcm) installed.

```
git clone https://github.com/thoughtbot/dotfiles.git ~/.thoughtbot-dotfiles
git clone https://github.com/hiattp/dotfiles.git ~/.hiattp-dotfiles
env RCRC=$HOME/.hiattp-dotfiles/rcrc rcup
```

## Other Notes:

The flavor du jour of runtime version managers (as far as these dotfiles are
concerned) is [asdf-vm](https://asdf-vm.com/). You'll want to follow install
instructions there if you didn't pull it in via the laptop script above. Also
keep in mind that `asdf` may generate shims for things like `node`, so if you
install a different node version with homebrew and do something like `brew
unlink node` you'll also need to ensure you aren't pointing to a shim (i.e.
check `which node`) and potentially remove it before linking a different
version.

If you use Heroku you might want to use
[heroku accounts](https://github.com/heroku/heroku-accounts) and
[heroku-binstubs](https://github.com/tpope/heroku-binstubs).

The laptop script installs
[universal-ctags](https://github.com/universal-ctags/ctags) so
be sure to run a `ctags` command, e.g. for Rails projects:

    ctags -R --languages=ruby --exclude=.git --exclude=log -f tags . $(bundle list --paths)
