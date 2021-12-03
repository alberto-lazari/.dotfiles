ln -s $PWD/.{[^.^\(git\)]*,git?*} -t ~/

if [[ $1 == "--zsh" ]]; then
	ln -s $PWD/zsh/.[^.]* -t ~/
else
	ln -s $PWD/bash/.[^.]* -t ~/
fi
