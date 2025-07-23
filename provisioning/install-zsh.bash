#!/bin/env bash
if [ ! -d /home/vagrant/.oh-my-zsh ]; then
    sudo apt update
    sudo apt-get install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
