#!/bin/sh -eu

script_dir="$(dirname "$(readlink -f $0)")"

print_help () {
    echo 'usage: macos-install.sh SHELL' >& 2
    echo 'SHELL = bash | zsh'
}

alert () {
    print_help
    exit 1
}

# Check if $1 is provided
[ ${1:-unset} = unset ] && alert

shell=$1

(grep -E 'bash|zsh' <<< $shell > /dev/null) || alert

for file in $script_dir/default/.[^.]* $script_dir/default/macos/$shell/.[^.]*
do
    cp "$file" "$script_dir"
    
    actual_file=$(echo $script_dir/$(basename "$file"))
    home_file="$HOME/$(basename "$file")"

    ([ -f $home_file ] || [ -L $home_file ]) && rm $home_file
    ln -s $actual_file $home_file
done
