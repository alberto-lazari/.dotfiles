#!/bin/bash -eu

cd $(dirname $BASH_SOURCE)

# Default zsh variables values
ZSH=${ZSH:-~/.oh-my-zsh}
ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

! overwrite ~/.zshrc || ln -s $(readlink -f zshrc) ~/.zshrc

# Install Oh My Zsh
[[ -d $ZSH ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
[[ -d $ZSH_CUSTOM/themes/powerlevel10k ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Install custom plugins
for repo in $(cat plugins.zsh | grep -v '^#'); do
    plugin=${repo/*\//}

    [[ -d $ZSH_CUSTOM/plugins/$plugin ]] || git clone https://github.com/$repo $ZSH_CUSTOM/plugins/$plugin
done
