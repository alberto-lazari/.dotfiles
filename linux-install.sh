global() {
    ln -s $PWD/.{[^.^\(git\)]*,git?*} -t ~/
}

if [[ $1 == "bash" ]]; then
    global
	ln -s $PWD/bash/.[^.]* -t ~/
elif [[ $1 == "zsh" ]]; then
    echo "not yet implemented..."
    #global
	#ln -s $PWD/zsh/.[^.]* -t ~/
else
    echo "usage: install-linux.sh [bash | zsh]"
fi
