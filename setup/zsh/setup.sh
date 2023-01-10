#!/bin/bash -eu

# Default zsh variables values
ZSH=${ZSH:-~/.oh-my-zsh}
ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

# Load eventual custom zsh variables set in zshrc
[[ ! -L ~/.zshrc || -e ~/.zshrc ]] || . ~/.zshrc

# Install Oh My Zsh
[[ -d $ZSH ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
[[ -d $ZSH_CUSTOM/themes/powerlevel10k ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Install custom plugins
for repo in $(cat plugins.zsh)
do
    plugin=${repo/*\//}

    [[ -d $ZSH_CUSTOM/plugins/$plugin ]] || git clone https://github.com/$repo $ZSH_CUSTOM/plugins/$plugin
done
