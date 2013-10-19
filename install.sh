#!/bin/sh

warn() {
  echo "$1" >&2
}

die() {
  warn "$1"
  exit 1
}

cd ~

echo "Making backup of existing ~/.vim ~/.vimrc ~/.gvimrc ..."

[ -e ~/.vim ] && mv -i ~/.vim ~/.vim.backup
[ -e ~/.vimrc ] && mv -i ~/.vimrc ~/.vimrc.backup
[ -e ~/.gvimrc ] && mv -i ~/.gvimrc ~/.gvimrc.backup

git clone git://github.com/amal-khailtash/dotvim.git .vim

# Set up the symlinks to vimrc and gvimrc
echo "Making symlinks ~/.vimrc ~/.gvimrc ..."
ln -s ~/.vim/_vimrc ~/.vimrc
ln -s ~/.vim/_gvimrc ~/.gvimrc

cd ~/.vim

echo "Initializing Vundle"
git submodule init
git submodule update

echo "All Done"
