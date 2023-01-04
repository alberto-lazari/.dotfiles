#!/bin/bash -eu

script_dir="$(dirname "$(readlink -f $0)")"

print_help () {
    echo 'usage: install.sh SHELL' >& 2
    echo 'SHELL = bash | zsh'
}

case $(uname) in
    Darwin) os=macos;;
    Linux)  os=linux;;
    *)      echo OS not supported >& 2; exit 1;;
esac

# Check if $1 is provided
[ ${1:-unset} = unset ] && { print help; exit 1; }

shell=$1

([ $os = linux ] && [ $shell = zsh ]) && { echo zsh is not yet supported on Linux >& 2; exit 1; }

(echo $shell | grep -E 'bash|zsh' > /dev/null) || { print_help; exit 1; }

for file in $script_dir/default/.[^.]* $script_dir/default/$os/$shell/.[^.]*
do
    cp "$file" "$script_dir"
    
    actual_file=$(echo $script_dir/$(basename "$file"))
    home_file="$HOME/$(basename "$file")"

    ([ -f $home_file ] || [ -L $home_file ]) && rm $home_file
    case $os in
        macos)  ln -s $actual_file $home_file;;
        linux)  ln -s $actual_file -t ~/;;
    esac
done
