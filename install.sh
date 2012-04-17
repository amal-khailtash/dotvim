#!/bin/sh

warn() {
  echo "$1" >&2
}

die() {
  warn "$1"
  exit 1
}

cd ~

[ -e ~/.vim ] && mv -i ~/.vim ~/.vim.backup
[ -e ~/.vimrc ] && mv -i ~/.vimrc ~/.vimrc.backup
[ -e ~/.gvimrc ] && mv -i ~/.gvimrc ~/.gvimrc.backup

git clone git://github.com/amal-khailtash/dotvim.git .vim

cd ~/.vim

# Set up the symlinks to vimrc and gvimrc
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/gvimrc ~/.gvimrc

git submodule init
git submodule update

