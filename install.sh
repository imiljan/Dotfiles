#!/bin/bash
# install.sh
# This script bootstraps a fresh macOS system with the user's dotfiles and tools.

########## Variables ##########
dir=~/Dotfiles                                    # Dotfiles directory
olddir=~/Dotfiles_old                             # Backup directory for existing configs
files="zshrc profile gitconfig gitignore vimrc ideavimrc alias" # Top-level files to link

config=~/.config                                  # XDG config directory
dirs="aerospace bat borders btop eza ghostty lazygit nvim starship" # Directories to link into ~/.config

bins="fix-tilde irg tmux-chooser tmux-sessionizer" # Scripts to link into ~/.local/bin
##########

echo -e "\nStarting installation...\n"

echo -n "Changing to the $dir directory ..."
cd $dir || exit
echo "done"

# 1. Install Homebrew & Packages
echo -e "\n=== Step 1: Installing Homebrew & Packages ==="
echo "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
	echo "Installing brew (this may take a while)..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew is already installed."
fi

echo "Installing brew packages from Brewfile..."
brew bundle install --no-lock

# 2. Backup & Prepare Directories
echo -e "\n=== Step 2: Preparing Directories ==="
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

echo "Ensuring configuration directories exist..."
mkdir -p "$config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$config/tmux"

# 3. Symlink Dotfiles
echo -e "\n=== Step 3: Symlinking Dotfiles ==="
for f in $files; do
	echo "Processing .$f..."
	mv ~/."$f" ~/Dotfiles_old/ 2>/dev/null
	echo "  - Backed up to $olddir"
	ln -sf $dir/"$f" ~/."$f"
	echo "  - Created symlink"
done

# 4. Symlink Config Directories
echo -e "\n=== Step 4: Symlinking Config Directories ==="
for d in $dirs; do
	echo "Linking $d configuration..."
	rm -rf "$config/$d"
	ln -s $dir/"$d" $config/"$d"
done

# 5. Tmux Configuration
echo -e "\n=== Step 5: Configuring Tmux ==="
echo "Linking tmux.conf..."
ln -sf $dir/tmux.conf $config/tmux/tmux.conf

echo "Checking for Tmux Plugin Manager (tpm)..."
if [ ! -d "$config/tmux/plugins/tpm" ]; then
	echo "Installing tpm..."
	git clone https://github.com/tmux-plugins/tpm $config/tmux/plugins/tpm
else
	echo "tpm already installed."
fi

# 6. Symlink Binaries
echo -e "\n=== Step 6: Symlinking Binaries ==="
for b in $bins; do
	echo "Linking binary $b..."
	ln -sf $dir/bin/"$b" ~/.local/bin/"$b"
done

# 7. Zsh & Oh-My-Zsh Setup
echo -e "\n=== Step 7: Configuring Zsh ==="
install_zsh() {
	if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ] || command -v zsh &>/dev/null; then
		if [[ ! -d ~/.oh-my-zsh/ ]]; then
			echo "Cloning Oh My Zsh..."
			git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
		else
			echo "Oh My Zsh already installed."
		fi

		if [[ ! $(echo "$SHELL") == $(which zsh) ]]; then
			echo "Changing default shell to zsh..."
			chsh -s $(which zsh)
		fi
	else
		platform=$(uname)
		if [[ $platform == 'Linux' ]]; then
			if [[ -f /etc/redhat-release ]]; then
				sudo yum install zsh
				install_zsh
			fi
			if [[ -f /etc/debian_version ]]; then
				sudo apt-get install zsh
				install_zsh
			fi
		elif [[ $platform == 'Darwin' ]]; then
			echo "Please install zsh (should have been installed by brew), then re-run this script!"
			exit
		fi
	fi
}

install_zsh

echo "Installing zsh plugins..."
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
	echo "  - zsh-syntax-highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	echo "  - zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
fi

# 8. Bat Theme
echo -e "\n=== Step 8: Configuring Bat Theme ==="
if command -v bat &>/dev/null; then
	mkdir -p "$(bat --config-dir)/themes"
	cd "$(bat --config-dir)/themes" || exit
	if [ ! -f "tokyonight_night.tmTheme" ]; then
		echo "Downloading Tokyonight theme..."
		curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
		bat cache --build
	else
		echo "Bat theme already exists."
	fi
else
	echo "Bat is not installed, skipping theme installation."
fi

echo -e "\n✅ Installation Complete!\n"

echo -e "=========================================="
echo -e " MANUAL STEPS REQUIRED AFTER INSTALLATION"
echo -e "=========================================="
echo -e "1. Raycast Configuration:"
echo -e "   - Open Raycast."
echo -e "   - Go to Settings > Advanced > Import/Export."
echo -e "   - Import the config from: ~/Dotfiles/raycast.rayconfig"
echo -e ""
echo -e "2. Authenticate CLI Tools:"
echo -e "   - GitHub CLI: Run 'gh auth login'"
echo -e ""
echo -e "3. Install 'tk' Tool:"
echo -e "   - Your .zshrc tries to run 'tk shell-setup'."
echo -e "   - Install the 'tk' tool manually to avoid 'command not found' errors."
echo -e ""
echo -e "4. Log in to Applications:"
echo -e "   - 1Password, Slack, Notion, Spotify, etc."
echo -e ""
echo -e "5. Secrets:"
echo -e "   - Ensure '~/Dotfiles/secrets' exists and contains your API keys/tokens."
echo -e "   - Note: .zshrc sources this specific path."
echo -e "=========================================="
