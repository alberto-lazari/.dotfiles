# sh
These are the base files that gather common configurations between various shells

They are supposed to be sourced from the specific configuration files of the actual shell, building more complex configurations on top of them

## Files
- `profile` should contain configurations that every shell must have, even scripting ones, like additional `PATH` directories
- `shrc` should define every interactive-related aspects, which means everything you want to have on a shell you actually type on through a terminal
- `aliases` are custom commands definitions and additional, small functions to deal with everyday tasks.
  They are meant to be used on interactive shells

### Local configurations
`profile` and `aliases` allow for local additional configurations (`~/.config/sh/profile.local` and `~/.config/sh/aliases.local`), that you may not want to sync on all systems or are needed only on a specific one

## Support
I use them for both Bash and Zsh.
Code style has to be a careful blend of POSIX and slight bashisms (compatible with Zsh)

They are not to be used as actual POSIX sh dotfiles.
They are in a `sh` directory just because every system will have it as a command, so it will be installed regardless of the shell present on the system
