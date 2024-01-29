# Dotfiles
My personal collection of dotfiles for macOS and Linux systems

## Why?
[This video](https://www.youtube.com/watch?v=mSXOYhfDFYo) is great for understanding the purpose of a dotfiles repo and how basic bash scripting works in general

## Installation
Clone the repo in your home directory with
```bash
git clone https://github.com/albertolazari/.dotfiles ~/.dotfiles
```

Then run the [`install`](install) script that automatically creates the symlinks and sets up installed programs

`-h or --help` for usage and available options

## Program setups
Each file is placed into its own program directory, ready to be symlinked in the actual `~/.config` directory

Programs can use specific setup scripts, in order to define a different config directory or do more custom setup steps (like installing plugins)
