#!/bin/bash

if test ! $(which brew); then
    echo "Installing homebrew"
fi

brew install --cask alacritty
brew install --cask discord          
brew install --cask postman          
brew install --cask slack
brew install --cask spotify
brew install docker
brew install fnm
brew install fzf
brew install git
brew install jq
brew install python
brew install starship
brew install zoxide
brew install tmux
brew install tmuxinator
brew install pipenv
brew install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
curl -sS https://webi.sh/nerdfont | sh
brew tap epk/epk
Brew install npm


brew tap homebrew/cask-fonts
brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/jeffreytse/zsh-vi-mode \
  $ZSH_CUSTOM/plugins/zsh-vi-mode

brew install lazygit

# install neovim
brew install neovim

exit 0
