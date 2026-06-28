dotfiles
========

Dot files I use various places.

Now with [rcm](http://thoughtbot.github.io/rcm/) support! To install:

  - clone this repo
  - grab any git submodules: `git submodule init; git submodule update`
  - [install rcm](https://github.com/thoughtbot/rcm#installation)
  - run `rcm-install` (presumably from your home directory) to automagically get all the dotfile goodness.

## Source Code Pro Font

Download a zip file from [the Adobe GitHub repo](https://github.com/adobe-fonts/source-code-pro), unpack it and if on a Mac use the Font Book app to install it.

In terminal preferences set the font to Source Code Pro Regular (either 11 or 12 point, depending).

## FZF

Use Homebrew to install fzf. Also, be sure to install the key binding using:

```
$(brew --prefix)/opt/fzf/install
```

Go ahead and have it update the shell configurations when asked.

## Neovim

Install neovim via Homebrew:

```
brew install neovim
```

The config lives at `config/nvim/init.lua` in this repo, which rcm symlinks to
`~/.config/nvim/init.lua`. It self-bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim)
on first launch — just open `nvim` and lazy will install itself and all plugins automatically.

After plugins install, run `:Lazy sync` to get the latest versions and generate a fresh
`lazy-lock.json` (not tracked here — it's machine-specific).

Language servers are managed via [Mason](https://github.com/williamboman/mason.nvim) and
install automatically. Copilot requires a one-time auth step:

```
:Copilot setup
```

## VirtualBox Guest Additions

To get guest editions to run warning free on Ubuntu, install this package:

```
$ sudo apt-get install virtualbox-guest-dkms
```
