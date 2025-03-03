# Dotfiles
My personal collection of multi-platform dotfiles

## Why?
[This video](https://www.youtube.com/watch?v=mSXOYhfDFYo) is great for understanding the purpose of a dotfiles repo and how basic bash scripting works in general.

## Installation
Clone this repo in your home directory with
```bash
git clone https://github.com/alberto-lazari/.dotfiles ~/.dotfiles
```

Then run the [`install`](install) script that automatically creates the symlinks and sets up installed programs.

`-h` or `--help` for usage and available options.

### Windows
On Windows some preliminary steps are required to even have a shell...

The [setup](windows-setup.ps1) installs the basic tools I need on a system,
before installing the actual dotfiles.

Run it with
```powershell
curl.exe https://raw.githubusercontent.com/alberto-lazari/.dotfiles/refs/heads/main/windows-setup.ps1 | powershell
```

## Program setups
Each file is placed into its own program directory, ready to be symlinked in the actual `~/.config` directory.

Programs can use specific setup scripts, in order to define a different config directory or do more custom setup steps (like installing plugins).
