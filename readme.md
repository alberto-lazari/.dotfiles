# Dotfiles
My personal collection of dotfiles for MacOS and Linux that I currently use.

If you are reading this you may be interested in the way I configure and use my *NIX systems or in finding a complete and robust configuration for your system. If the latter is your case, I'm sorry to say that you are in the wrong place. The world is not perfect and so am I...

## Installation
Use [`macos-install.sh`](macos-install.sh) or [`linux-install.sh`](linux-install.sh) automated scripts to create symlinks on your home directory. The actual files will be the ones copied in the root directory of this repo (thus in /path/to/.dotfiles/) from the ones in [`default`](default). This way the originals are never modified, while the used ones will not be versioned (unless the originals are overwritten by them)

## Supported shells
For MacOS both bash and zsh are supported. Linux is mostly configured for bash, but a minimal configuration for zsh is also given. This reflects my personal usage of these OSes, and may vary over time, or maybe not
