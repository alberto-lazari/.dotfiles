# Dotfiles
My personal collection of dotfiles for MacOS and Linux that I currently use.

If you are reading this you may be interested in the way I configure and use my \*NIX systems or in finding a complete and robust configuration for your system. If the latter is your case, I'm sorry to say that you are looking in the wrong place. The world is not perfect and so am I...

## Installation
Use the [`install.sh`](install.sh) automated script to create symlinks on your home directory. The script is completely automated and installs based on platform (macOS/Linux) and installed programs (vim, zsh)

`-h or --help` for usage and available options

## Custom setup
Every optional program configuration is configured with a `program/setup.sh` script, that cares about installing the base configuration, along with custom plugins. This way, running the setup once, gets you a completely ready-to-use environment

### Vim
The vim configuration is done using the specific [`vim/setup.sh`](vim/setup.sh), that puts [`vimrc`](vim/vimrc) and the specified plugins in `~/.vim/`

All the specified plugins in [`plugins.vim`](vim/plugins.vim) will be installed and enabled by vim on startup, and can be ignored by running vim with `vim --noplugin`

### Zsh
Similarly to vim, zsh configuration is handled by [`zsh/setup.sh`](zsh/setup.sh). It creates relevant symlinks and installs Oh My Zsh, if not already present on the system. It also installs all the plugins listed in [`plugins.zsh`](zsh/plugins.zsh), the file used to enable them in [`.zshrc`](zsh/zshrc) too

## Local hooks
[`.zshrc`](zsh/zshrc), [`.bashrc`](base/bashrc) and [`.alias`](base/alias) use hooks to add local configurations to each file respectively

For instance, my general `.bashrc` could be like this:
```bash
export PS1='\$ '

export PATH="$HOME/bin:$PATH"

...
```

Then, for a specific configuration I want to add to my `.bashrc.local` this:
```bash
neofetch

export PATH="/custom/path/bin:$PATH"
```

`.bashrc.local` will not be versioned in this repo, this way I can have a global configuration and local small changes, depending on the system I am using
