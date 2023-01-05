# Dotfiles
My personal collection of dotfiles for MacOS and Linux that I currently use.

If you are reading this you may be interested in the way I configure and use my \*NIX systems or in finding a complete and robust configuration for your system. If the latter is your case, I'm sorry to say that you are in the wrong place. The world is not perfect and so am I...

## Installation
Use the [`install.sh`](install.sh) automated script to create symlinks on your home directory

## Supported shells
For MacOS both bash and zsh are supported, while Linux is mostly configured just for bash. This reflects my personal usage of these OSes, and may vary over time, or maybe not

## Local hooks
[`.zshrc`](macos/zshrc), [`.bashrc`](bashrc) and [`.alias`](alias) use hooks to add local configurations to each file respectively.
For instance, my general `.bashrc` could be like this:
```
export PS1='\$ '

export PATH="$HOME/bin:$PATH"

...
```

Then, for a specific configuration I want to add to my `.bashrc.local` this:
```
neofetch

export PATH=".:$PATH"
```

`.bashrc.local` will not be versioned in this repo, this way I can have a global configuration and local small changes, depending on the system I am using
