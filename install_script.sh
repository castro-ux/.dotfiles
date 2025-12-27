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
    hyprland alacritty hyprpaper hypridle hyprlock stow 
    ttf-jetbrains-mono-nerd 
    github-cli tmux neovim 
    tree gimp qutebrowser zsh unzip 
    dolphin dmenu
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


# Ensure the base config directory exists first
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$XDG_CONFIG_HOME"

# --- MANUAL SYMLINKS FOR EXISTING CONFIGS ---
echo "Setting up manual symlinks..."

# Original Configs going into ~/.config/
# Using -sf (s: symbolic, f: force/overwrite)
ln -sf "$HOME/.dotfiles/hypr/.config/hypr" "$XDG_CONFIG_HOME/"
ln -sf "$HOME/.dotfiles/alacritty/.config/alacritty" "$XDG_CONFIG_HOME/"

# Shell configs going into ~/ (Home)
ln -sf "$HOME/.dotfiles/zshrc/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/.dotfiles/bashrc/.bashrc" "$HOME/.bashrc"

# Oh-My-Zsh setup
mkdir -p "$XDG_CONFIG_HOME/oh-my-zsh"
ln -sf "$HOME/.dotfiles/oh-my-zsh/.oh-my-zsh.sh" "$XDG_CONFIG_HOME/oh-my-zsh/oh-my-zsh.sh"

echo "Symlinks created successfully."


# # --- CONFIGURATION SETUP (STOW) ---
# echo "Setting up user configs with GNU Stow..."

# if [ -d "$HOME/.dotfiles" ]; then
#     cd "$HOME/.dotfiles"
    
#     if [ "$DRY_RUN" = true ]; then
#         echo "[DRY-RUN] rm -rf ~/.config/hypr ~/.config/alacritty"
#         echo "[DRY-RUN] stow -vRt ~ hypr"
#         echo "[DRY-RUN] stow -vRt ~ alacritty"
#     else
#         # 1. Clear existing physical folders to prevent "Operation aborted" errors
#         rm -rf ~/.config/hypr ~/.config/alacritty 

#         # 2. Ensure parent exists and stow
#         mkdir -p ~/.config
#         stow -vRt ~ hypr
#         stow -vRt ~ alacritty
        
#         echo "Symlinks created successfully."
#     fi
# else
#     echo "Error: ~/.dotfiles directory not found."
# fi


# --- FONT CACHE ---
if [ "$DRY_RUN" != true ]; then
    fc-cache -f
fi

echo "Install Finished. DRY_RUN=$DRY_RUN"
