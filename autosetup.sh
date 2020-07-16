#! /bin/bash

if [ -f "~/.zshrc" ]; then
  echo "Renaming existing $FILE"
  mv ~/.zshrc ~/.zshrc_bak
fi

ln -sf ~/.zshrc ./.zshrc
