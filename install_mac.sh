#! /bin/bash


# xcode-select —-install

# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew install zsh

# curl -L git.io/antigen > antigen.zsh

PATH_ZSH=$(which zsh)
grep -q -F "$PATH_ZSH" /etc/shells
if [ $? -ne 0 ]; then
  echo "Adding zsh to /etc/shells"
  echo "$PATH_ZSH" | sudo tee -a "/etc/shells"
fi

echo "Changing your current shell to zsh"
chsh -s $PATH_ZSH


brew cask install iterm2



