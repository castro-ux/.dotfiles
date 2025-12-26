#!/bin/bash
set -e

# --- TOGGLE THIS TO RUN ---
DRY_RUN=false  #set to false to install

# --- LOGGING ---
release_file=/etc/os-release

# --- DETECT OS ---
if ! grep -qi "Arch" "$release_file"; then
    echo "This script is for Arch Linux only."
    exit 1
fi
echo "Arch Linux detected"

# --- PACKAGES TO INSTALL ---
PACKAGES=(
     hyprpaper hypridle hyprlock stow 
    ttf-jetbrains-mono-nerd 
    #github-cli tmux neovim 
    #libreoffice-fresh tree gimp qutebrowser zsh unzip
)

# --- CHECK AND INSTALL PACKAGES ---
packages_to_install=()
for package in "${PACKAGES[@]}"; do
    if ! pacman -Q "$package" &>/dev/null; then
        packages_to_install+=("$package")
    fi
done

if [ ${#packages_to_install[@]} -gt 0 ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] sudo pacman -S --noconfirm ${packages_to_install[*]}"
    else
        sudo pacman -S --noconfirm "${packages_to_install[@]}"
    fi
fi

# --- CONFIGURATION SETUP (STOW) ---
echo "Setting up user configs with GNU Stow..."

if [ -d "$HOME/.dotfiles" ]; then
    cd "$HOME/.dotfiles"
    
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] stow -vRt ~ hypr"
        echo "[DRY-RUN] stow -vRt ~ alacritty"
    else
        # Optional: Uncomment the next line ONCE if you want the script to clear the old mess for you
        # rm -rf ~/.config/hypr ~/.config/alacritty 

        mkdir -p ~/.config
        stow -vRt ~ hypr
        stow -vRt ~ alacritty
        echo "Symlinks created successfully."
    fi
else
    echo "Error: ~/.dotfiles directory not found."
fi

# --- FONT CACHE ---
if [ "$DRY_RUN" != true ]; then
    fc-cache -f
fi

echo "Install Finished. DRY_RUN=$DRY_RUN"
