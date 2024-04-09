#!/bin/bash

########## Variables
dir=~/Dotfiles
olddir=~/Dotfiles_old
files="zshrc profile gitconfig vimrc ideavimrc alias"

config=~/.config
dirs="nvim lazygit"

bins="tmux-sessionizer fix-tilde"
##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

for f in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$f ~/Dotfiles_old/
    echo "Creating symlink to $f in home directory."
    ln -s $dir/$f ~/.$f
done

for d in $dirs; do
    echo "Creating symlink to $d in ~/.config directory."
    ln -s $dir/$d ~/.config/$d
done

mkdir ~/.config/tmux
ln -s $dir/tmux.conf ~/.config/tmux/tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

for b in $bins; do
    echo "Creating symlink to $b in ~/.local/bin directory."
    ln -s $dir/bin/$b ~/.local/bin/$b
done

 install_zsh () {
 # Test to see if zshell is installed.  If it is:
 if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
     # Clone my oh-my-zsh repository from GitHub only if it isn't already present
     if [[ ! -d ~/.oh-my-zsh/ ]]; then
         git clone http://github.com/robbyrussell/oh-my-zsh.git ~/
     fi
     # Set the default shell to zsh if it isn't currently set to zsh
     if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
         chsh -s $(which zsh)
     fi
 else
     # If zsh isn't installed, get the platform of the current machine
     platform=$(uname);
     # If the platform is Linux, try an apt-get to install zsh and then recurse
     if [[ $platform == 'Linux' ]]; then
         if [[ -f /etc/redhat-release ]]; then
             sudo yum install zsh
             install_zsh
         fi
         if [[ -f /etc/debian_version ]]; then
             sudo apt-get install zsh
             install_zsh
         fi
     # If the platform is OS X, tell the user to install zsh :)
     elif [[ $platform == 'Darwin' ]]; then
         echo "Please install zsh, then re-run this script!"
         exit
     fi
 fi
 }

install_zsh

# Add zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

