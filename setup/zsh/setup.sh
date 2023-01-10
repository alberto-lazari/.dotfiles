#!/bin/bash -eu

# Install Oh My Zsh
[[ -d ${ZSH:-~/.oh-my-zsh} ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
[[ -d $ZSH_CUSTOM/themes/powerlevel10k ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install custom plugins
for repo in $(cat plugins.zsh)
do
    plugin=${repo/*\//}

    [[ -d $ZSH_CUSTOM/plugins/$plugin ]] || git clone https://github.com/$repo $ZSH_CUSTOM/plugins/$plugin
done
