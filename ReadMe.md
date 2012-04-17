Here is m .vim setup.

Install
=======

### Automatic Install ###

Run this from your terminal:

    curl https://raw.github.com/amal-khailtash/dotvim/master/install.py | python

### Manual Install ###

Get it from git:

  % cd $HOME
  % mv .vim .vim.backup
  % mv .vimrc .vimrc.backup
  % mv .gvimrc .gvimrc.backup
  % git clone git://github.com/amal-khailtash/dotvim.git .vim

  % ln -s $HOME/.vim/vimrc $HOME/.vimrc
  % ln -s $HOME/.vim/gvimrc $HOME/.gvimrc

  % cd $HOME/.vim
  % git submodule init
  % git submodule update

