#
# root/.bashrc
#

alias ls='ls --color=auto'
alias ll='ls -al'

PS1='\[\e[1;31m\]\u'
PS1+='\[\e[0m\]@'
PS1+='\[\e[0m\]\h '
PS1+='\[\e[1;32m\]\w '
PS1+='\[\e[0m\]# '

export PS1

