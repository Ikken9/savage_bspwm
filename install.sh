#!/bin/bash

if [ "$(whoami)" == "root" ]; then
    echo 'Error: Cannot run from root, you need to switch to your user.'
    exit 1
fi

EDGERUNNER=$(pwd)

mkdir ~/temp
cd ~/temp

# Install bspwm + sxhkd dependencies
sudo apt-get install libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev

# Install and configure bspwm + sxhkd
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git
cd bspwm && make && sudo make install
cd ../sxhkd && make && sudo make install

sudo cp -rv $EDGERUNNER/config/bspwm ~/.config
sudo cp -rv $EDGERUNNER/config/sxhkd ~/.config

sudo chmod u+x ~/.config/bspwm/bspwmrc

# Install Hack Nerd Fonts
cp $EDGERUNNER/fonts/*.ttf /usr/share/fonts

# Install and configure polybar
sudo apt install polybar
sudo cp -rvf $EDGERUNNER/config/polybar ~/.config
sudo chmod +x ~/.config/polybar/launch.sh

# Install and configure kitty terminal emulator
sudo apt install -y kitty
sudo cp -rv $EDGERUNNER/config/kitty ~/.config

# Install and configure Rofi
sudo apt install -y rofi
mkdir -p ~/.local/share/rofi/themes/
sudo cp -rfv $EDGERUNNER/config/rofi/themes ~/.local/share/rofi

# Install other stuff
sudo apt install -y fzf feh ranger bat lsd neofetch

# Install rust support
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install libssl-dev
sudo apt install libssl-dev

# Install mdcat
git clone https://github.com/swsnr/mdcat.git
cd mdcat
cargo install mdcat

# Set wallpaper
mkdir ~/Pictures/Wallpapers
cp -v $EDGERUNNER/wallpapers/wallpaper.png ~/Picture/Wallpapers

# Install ZSH and migrate to it
sudo apt install zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# Install and configure Powerlevel10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k

cp -rfv $EDGERUNNER/.p10k.zsh ~/.p10k.zsh
sudo cp -rv $EDGERUNNER/.p10k.zsh-root /root/.p10k.zsh

# Configure ZSH
sudo cp -rfv $EDGERUNNER/.zshrc ~

# Create symlink between default user zshrc and root zshrc
sudo ln -s -fv ~/.zshrc /root/.zshrc

# Install ZSH plugins
sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions
sudo mkdir /usr/share/zsh-sudo
cd /usr/share/zsh-sudo
sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# Install picom dependencies
sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl-dev libegl-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson

# Install and configure picom
cd ~/temp
git clone https://github.com/yshui/picom.git
cd picom
ninja -C build install
cp $EDGERUNNER/config/picom ~/.config

cd ~
rofi-theme-selector

sudo rm -rf ~/temp
reboot