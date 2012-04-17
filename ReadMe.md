Here is my .vim setup.

Install
=======

### Automatic Install ###

Run the following your terminal

(using curl)

    curl https://raw.github.com/amal-khailtash/dotvim/master/install.sh | sh

(using wget)

    wget https://raw.github.com/amal-khailtash/dotvim/master/install.sh -O - | sh

### Manual Install ###

Get it from git:

    % cd ~
    % mv -i .vim .vim.backup
    % mv -i .vimrc .vimrc.backup
    % mv -i .gvimrc .gvimrc.backup
    
    % git clone git://github.com/amal-khailtash/dotvim.git .vim
    
    % ln -s ~/.vim/vimrc ~/.vimrc
    % ln -s ~/.vim/gvimrc ~/.gvimrc
    
    % cd ~/.vim
    
    % git submodule init
    % git submodule update

