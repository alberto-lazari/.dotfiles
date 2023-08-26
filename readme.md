# Dotfiles
My personal collection of dotfiles for MacOS and Linux that I currently use

## Installation
Clone the repo in your home directory with
```bash
git clone https://github.com/albertolazari/.dotfiles ~/.dotfiles
```

Then run the [`install.sh`](install.sh) script that automatically creates the symlinks and sets up installed programs

`-h or --help` for usage and available options

## Custom setup
Every optional program configuration is configured with a `program/setup.sh` script, that cares about installing the base configuration, along with custom plugins. This way, running the setup once, gets you a completely ready-to-use environment
