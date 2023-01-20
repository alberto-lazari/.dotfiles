#!/bin/bash -eu

cd $(dirname $BASH_SOURCE)

# Default zsh variables values
ZSH=${ZSH:-~/.oh-my-zsh}
ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

if [[ ! -d $ZSH ]]; then
    echo 'Installing Oh My Zsh... (once completed exit the prompt to continue with the installation)'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &> /dev/null
fi

if [[ ! -d $ZSH_CUSTOM/themes/powerlevel10k ]]; then
    echo 'Installing Powerlevel10k theme...'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2> /dev/null
fi

# Install custom plugins
for repo in $(cat plugins.zsh | grep -Ev '^#|^$'); do
    plugin=${repo/*\//}

    if [[ ! -d $ZSH_CUSTOM/plugins/$plugin ]]; then
        echo "Installing zsh plugin: $plugin..."
        git clone https://github.com/$repo $ZSH_CUSTOM/plugins/$plugin 2> /dev/null
    fi
done

# Create symlinks after the installations
! overwrite ~/.zshrc || ln -s $(readlink -f zshrc) ~/.zshrc
! overwrite ~/.p10k.zsh || ln -s $(readlink -f p10k.zsh) ~/.p10k.zsh
