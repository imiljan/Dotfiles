mkdir temp 
cd temp
sudo apt update && sudo apt upgrade -y

sudo apt install curl vim git wget -y
sudo apt install gnome-tweaks -y
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get install apt-transport-https -y
sudo apt-get update -y
sudo apt-get install code -y # or code-insiders

sudo snap install slack --classic
sudo snap install insomnia

curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.35.2/install.sh -o install_nvm.sh
bash install_nvm.sh
echo "export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion" >> .profile
source .profile
nvm install --lts

sudo touch /etc/apt/sources.list.d/google-chrome.list
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
wget https://dl.google.com/linux/linux_signing_key.pub
sudo apt-key add linux_signing_key.pub
sudo apt update
sudo apt install google-chrome-stable -y

sudo apt install gnome-shell-extensions -y
sudo apt install chrome-gnome-shell -y

wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.16.6016.tar.gz
sudo tar -xzvf jetbrains-toolbox-1.16.6016.tar.gz -C /opt

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce
sudo usermod -aG docker ${USER}
su - ${USER}

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo apt install zsh
chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cd ~/
rm -rf temp
echo All done!
