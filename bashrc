# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Vi keybindings
set -o vi

# No ESC timeout delay for vi keybindings
KEYTIMEOUT=1

# Custom prompt
PS1='\[\e[1;34m\]\w '
PS1+='\[\e[0m\]$ '
export PS1

# Load custom aliases
[[ ! ( -L ~/.alias || -f ~/.alias ) ]] || . ~/.alias

# Hook for non-versioned .bashrc.local
[[ ! -f ~/.bashrc.local ]] || . ~/.bashrc.local
