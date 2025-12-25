#!/bin/bash

# --- CONFIGURATION ---
TEST_MODE=false # Set to false to allow the script to actually run
# ---------------------

# 1. Detect Package Manager and Update System
if command -v pacman &> /dev/null; 
then
distro_cmd="pacman"
pkg_ins="sudo pacman -S --noconfirm"
update_cmd="sudo pacman -Syu --noconfirm"
elif command -v apt &> /dev/null; 
then
distro_cmd="apt"
pkg_ins="sudo apt install -y"
update_cmd="sudo apt update && sudo apt upgrade -y"
elif command -v apk &> /dev/null;
then
distro_cmd="apk"
pkg_ins="sudo apk add"
sudo sed -i 's/#//g' /etc/apk/repositories
update_cmd="sudo apk update && sudo apk upgrade"
fi

# 2. Universal Install Function with "Skip" Logic
install_pkg() {
local pkg=$1

# Check if the package is already installed
case "$distro_cmd" in
"pacman") pacman -Qi "$pkg" &> /dev/null ;;
"apt") dpkg -s "$pkg" &> /dev/null ;;
"apk") apk info -e "$pkg" &> /dev/null ;;
esac

if [ $? -eq 0 ]; then
echo "[SKIPPING]: $pkg is already installed."
else
if [ "$TEST_MODE" = true ]; then
echo "[DRY RUN]: Would install $pkg"
else
echo "[INSTALLING]: $pkg..."
case "$distro_cmd" in
"pacman") sudo pacman -S --noconfirm "$pkg" ;;
"apt") sudo apt install -y "$pkg" ;;
"apk") sudo apk add "$pkg" ;;
esac
fi
fi
}

# 3. Universal Packages (All Distros)
APPS=(github-cli tmux neovim libreoffice tree gimp qutebrowser zsh git unzip fontconfig curl)

# 4. Confirmation Logic
if [ "$TEST_MODE" = false ]; then
echo "!!! INSTALLATION INITIALIZING !!!"
echo "This will install: ${APPS[*]}"
[ "$distro_cmd" = "pacman" ] && echo "Plus: Hyprland suite, Stow, and JetBrains Mono Nerd Font."

echo -n "Proceed? (type 'yes'): "
read -r confirmation
if [ "$confirmation" != "yes" ]; then
echo "Installation cancelled."
exit 0
fi
fi

# 5. Execution: Updates and Universal Apps
if [ "$TEST_MODE" = false ]; then
eval "$update_cmd"
for app in "${APPS[@]}"; do
install_pkg "$app"
done
# OhMyZsh Unattended
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
echo "[DRY RUN] Would update system and install: ${APPS[*]}"
fi

# 5. Arch-Specific: Hyprland & Stow Dotfiles
if [ "$distro_cmd" = "pacman" ]; then
if [ "$TEST_MODE" = false ]; then
install_pkg "hyprlock"
install_pkg "hyprpaper"
install_pkg "hypridle"
install_pkg "stow"
install_pkg "ttf-jetbrains-mono-nerd"

DOT_DIR="$HOME/.dotfiles"
if [ ! -d "$DOT_DIR" ]; then
git clone https://github.com/castro-ux/.dotfiles "$DOT_DIR"
fi

# Stow logic: Symlinks repo files to config folders
cd "$DOT_DIR" || exit
stow .
cd - || exit
else
echo "[DRY RUN] Would install hypr suite, clone dotfiles, and run 'stow .'"
fi
fi

# 6. Post-Install Configs (Nvim Relative Numbers & Shell)
if [ "$TEST_MODE" = false ];
then
echo "Applying Neovim and Shell configurations..."

# Change Shell to ZSH
ZSH_PATH=$(which zsh)
[ "$distro_cmd" = "apk" ] && sudo apk add shadow
sudo chsh -s "$ZSH_PATH" "$USER"

# Refresh Font Cache
fc-cache -fv

echo "Success! Installation complete."
fi
