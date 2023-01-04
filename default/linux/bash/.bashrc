#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color'
alias ll='ls -l'
alias l='ls -al'
alias less='less -r'

# Git
alias s='git status'
alias a='git add'
alias cb='git checkout'
alias pull='git pull'
alias push='git push'
alias branch='git branch'
alias rebase='git rebase'
alias merge='git merge'
alias reset='git reset'
alias stash='git stash'
alias pop='git stash pop'
alias feature='git-flow feature'

# Git custom
cf() {
  git checkout "feature/${1}"
}
alias c='git commit -m'
alias rmbr='git branch -d'
alias publish='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias restore='git restore'
alias unstage='git restore --staged'
alias cleanbr='git branch -D `git branch | grep -v \* | xargs`'

PS1='\[\e[1;36m\]\w '
PS1+='\[\e[0m\]$ '
export PS1
