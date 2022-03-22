global() {
    ln -s $PWD/global/.[^.]* ~/
}

if [[ $1 == "bash" ]]; then
    global
	ln -s $PWD/macos/bash/.[^.]* ~/
elif [[ $1 == "zsh" ]]; then
    global
    ln -s $PWD/macos/zsh/.[^.]* ~/
else
    echo "usage: macos-install.sh [bash | zsh]"
fi
