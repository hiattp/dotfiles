These dotfiles are based on the [thoughtbot dotfiles](https://github.com/thoughtbot/dotfiles) (and [rcm](https://github.com/thoughtbot/rcm)), and are largely just overrides against thoughtbot's defaults based on
personal preference.

## New System Setup

Use the [thoughtbot laptop script](https://github.com/thoughtbot/laptop) to set
up a new machine. The `laptop.local` script here will install the following (not
included in the thoughtbot script by default):

1. MacVim
2. [Overmind](https://github.com/DarthSim/overmind)
3. Python (with Pip)
4. vips (image processing)
5. iTerm2
6. Google Chrome
7. Karabiner Elements
8. Dropbox
9. 1Password
10. Karabiner Elements
11. GitHub

```
git clone https://github.com/hiattp/dotfiles.git ~/.hiattp-dotfiles
cp ~/.hiattp-dotfiles/laptop.local ~/.laptop.local
curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log
```

NOTE: You'll want to adjust a few settings/parameters in the applications that
were installed:

1. In Karabiner Elements, go to "Complex modifications" and "Add rule" to find
   the Escape Multifunction behavior and enable it. Then choose "Parameters" and
   change `to_if_alone_timeout_miliseconds` to 500.
2. In Karabiner Elements, map Caps Lock to Escape as a "Simple modification".
3. In iTerm2 check Profiles > Default > Reuse previous sessions directory.
4. In iTerm2 change Profiles > Default > Terminal > Scroll back links to 10,000.
5. In OSX change the cursor speed and key repeat speed to highest, and
   delay until key repeat to lowest in the Mouse and Keyboard settings
   respectively.
6. In OSX enable Accessibility > Track Pad > Click Lock Drag.
7. In OSX Screensaver > Hot Corners set the bottom right to "Desktop" and bottom
   left to "Lock Screen".
8. In OSX check Trackpad > Tap to click and Tracking Speed to Fast.
9. In Chrome uncheck Chrome > Warn Before Quitting.
10. Configure/Setup Dropbox
11. Configure/Setup 1Password

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
