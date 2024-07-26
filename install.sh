#!/bin/bash

########## Variables
dir=~/Dotfiles
olddir=~/Dotfiles_old
files="zshrc profile gitconfig vimrc ideavimrc alias"

config=~/.config
dirs="nvim lazygit"

bins="fix-tilde irg tmux-chooser tmux-sessionizer"
##########

echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

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
echo "Creating symlink to $dit/tmux.conf ~/.config/tmux"
ln -s $dir/tmux.conf ~/.config/tmux/tmux.conf
echo "Installing tpm"
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

echo "Installing zsh/oh-my-zsh"
install_zsh

# Brew
echo "Installing brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing brew packages from Brewfile"
brew bundle install --no-lock


echo "Installing zsh plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Installing bat theme"
mkdir -p "$(bat --config-dir)/themes"
cd $(bat --config-dir)/themes
curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build

echo "DONE!"

