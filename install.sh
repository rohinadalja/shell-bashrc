#! /bin/sh

set -e
[ -z "$DEBUG" ] || set -x

cd "$(dirname "$0")/"

function assertInstalled() {
  for var in "$@"; do
    if ! command -v $var &> /dev/null; then
      echo "ERROR: '$var' is not installed... Please install this to continue."
      exit 1
    fi
  done
}
assertInstalled zsh git uname

OS_TYPE=$(uname -s)
if [ "$OS_TYPE" = "Darwin" ]; then
  ./install_mac.sh
else
  if [ "$OS_TYPE" = "Linux" ]; then
    ./install_linux.sh
  else
    echo "Unsupported OS Detected - Exiting Now."
    exit 1
  fi
fi

OHMY=.oh-my-zsh
OLD=/tmp/old

if [ -f "~/.zshrc" ]; then
  echo "Renaming existing $FILE"
  mv ~/.zshrc ~/.zshrc_$(date +%Y-%m-%d)
fi

ln -sf ~/.zshrc ./.zshrc

# ----

if [ ! -d $OLD ]; then
  mkdir -p $OLD
fi

# set up symlinks
echo "Creating sym links..."

FILES=`ls -a | grep "^\." \
  | sed \
      -e "1,2d" \
      -e "/\.git$/d" \
      -e "/\.gitmodules$/d" \
      -e "/\.config$/d" \
`

for FILE in $FILES
do
  DEST=$HOME/$FILE
  if [ -e $DEST ]; then
    mv $DEST $OLD/$FILE_$(date +%Y-%m-%d)
  fi
  ln -sf `pwd`/$FILE $HOME/$FILE
done

# install zsh config
echo "Installing zsh config..."
if [ -d $HOME/$OHMY ]; then
  echo "Error: oh-my-zsh is already installed... Skipping it's installation and exiting now."
  cp $HOME/$OHMY $OLD/$OHMY_$(date +%Y-%m-%d)
  exit 1
fi

git clone http://github.com/robbyrussell/oh-my-zsh.git $HOME/$OHMY

# ln -sf `pwd`/kumori.zsh-theme $HOME/$OHMY/themes/kumori.zsh-theme

# # oh-my-zsh plugins
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k
# git clone https://github.com/zdharma/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# # oh-my-zsh themes
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# # Update vim submodules
# cd .vim/bundle && git submodule update --init --recursive

echo "Changing shell to /bin/zsh ..."
chsh -s /bin/zsh