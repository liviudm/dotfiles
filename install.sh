#!/bin/bash

set -euo pipefail

echo "Switch keyboard § character to \`..."
mkdir -p ${HOME}/Library/LaunchAgents/
cat <<EOF >${HOME}/Library/LaunchAgents/com.user.loginscript.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.loginscript</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035, "HIDKeyboardModifierMappingDst":0x700000064}, {"HIDKeyboardModifierMappingSrc":0x700000064, "HIDKeyboardModifierMappingDst":0x700000035}, {"HIDKeyboardModifierMappingSrc":0x700000039, "HIDKeyboardModifierMappingDst":0x700000029}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
launchctl load ${HOME}/Library/LaunchAgents/com.user.loginscript.plist

echo "Setting hostname..."
sudo scutil --set HostName liviudm.stackbricks.com
sudo scutil --set LocalHostName liviudm
sudo scutil --set ComputerName liviudm

echo "Enabling Firewall..."
sudo /usr/libexec/ApplicationFirewall/socketfilterfw \
	--setblockall off \
	--setallowsigned on \
	--setallowsignedapp on \
	--setloggingmode on \
	--setstealthmode on \
	--setglobalstate on

echo "Installing commandline tools..."
xcode-select --install

echo "Installing Rosetta..."
sudo softwareupdate --install-rosetta --agree-to-license

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(
	echo
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
) >>/Users/liviudm/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off

echo "Adding Homebrew taps..."
brew tap homebrew/cask-fonts

echo "Installing brew packages..."
# OS Base
brew install \
	fd \
	fzf \
	gcc \
	gnu-sed \
	gnupg \
	jq \
	lazygit \
	mas \
	neovim \
	pinentry-mac \
	reattach-to-user-namespace \
	ripgrep \
	sf-symbols \
	tmux \
	wget \
	ykman \
	yq
brew install \
	go \
	luarocks \
	node \
	rust

# DevOps Tools
brew install \
	terraform \
	terraform-ls
# Casks
brew install --cask \
	amethyst \
	discord \
	font-hack-nerd-font \
	iterm2 \
	keepassxc \
	logseq \
	obsidian \
	signal \
	spotify \
	yubico-yubikey-manager \
	zoom

echo "Setting up oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Setting up tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Setting up dotfiles symlinks..."
ln -sf ${0:A:h}/.zshrc ${HOME}/.zshrc
ln -sf ${0:A:h}/.config ${HOME}/.config
ln -sf ${0:A:h}/.p10k.zsh ${HOME}/.p10k.zsh
ln -sf ${0:A:h}/.tmux.conf ${HOME}/.tmux.conf
ln -sf ${HOME}/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/notes ${HOME}

# Mac App Store Apps
mas install 1352778147 # Bitwarden
mas install 747648890  # Telegram
mas install 1147396723 # WhatsApp
mas install 904280696  # Things
mas install 1482454543 # Twitter

echo "Setting up MacOS defaults..."
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.dock "autohide" -bool true
defaults write com.apple.dock "show-recents" -bool false
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.finder ShowStatusBar -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
