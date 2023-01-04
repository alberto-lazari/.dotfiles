#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color'
alias ll='ls -l'
alias l='ls -al'
alias less='less -r'

PS1='\[\e[1;32m\]\w '
PS1+='\[\e[0m\]$ '
export PS1
