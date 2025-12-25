#!/bin/bash
set -e

# --- TOGGLE THIS TO RUN ---
DRY_RUN=true # Set to false to actually install

# --- LOGGING ---
release_file=/etc/os-release

# --- DETECT OS ---
# Fixed: Added '!' (not) and changed $release to $release_file
if ! grep -qi "Arch" "$release_file"; then
    echo "This script is for Arch Linux only."
    exit 1
fi
echo "Arch Linux detected"

# --- PACKAGES TO INSTALL ---
PACKAGES=(
    hyprland
    hyprpaper
    hypridle
    hyprlock 
    stow
    ttf-jetbrains-mono-nerd 
    github-cli 
    tmux 
    neovim 
    libreoffice-fresh 
    tree 
    gimp 
    qutebrowser 
    zsh 
    git 
    unzip
    brave-bin
)

# --- EXECUTE INSTALLATION ---
if [ ${#PACKAGES[@]} -gt 0 ]; then
    echo "Installing packages.."
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] sudo pacman -S --noconfirm ${PACKAGES[*]}"
    else
        sudo pacman -S --noconfirm "${PACKAGES[@]}"
    fi
else
    echo "No packages to install.."
fi

# --- CONFIGURATION SETUP ---
echo "Setting up user configs.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] mkdir -p ~/.config/hypr ~/.oh-my-zsh ~/.local/share/fonts/JetBrainsMono && cp /path/to/your/configs/* ~/.config/hypr/"
else
    mkdir -p ~/.config/hypr ~/.oh-my-zsh ~/.local/share/fonts/JetBrainsMono
    cp /path/to/your/configs/* ~/.config/hypr/
    # You can modify this to copy specific config files or to clone repos, etc.
fi

# --- FONT CACHE ---
echo "Rebuilding font cache.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] fc-cache -f"
else
    fc-cache -f
fi

# --- STOW CONFIGURATION ---
echo "Stowing configurations.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] cd ~/.config/ && cp -rf ~/.dotfiles/hypr/.config/. ~/.config/hypr && stow hypr"
else
    cd ~/.config/ || exit 1
    cp -rf ~/.dotfiles/hypr/.config/. ~/.config/hypr
    stow hypr
fi

# --- CLEANUP ---
echo "Cleaning up unnecessary packages.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] sudo pacman -Rns --noconfirm \$(pacman -Qtdq)"
else
    # Uses || true so the script doesn't crash if there are no orphans
    sudo pacman -Rns --noconfirm $(pacman -Qtdq) || true
fi

echo "Install Finished." 
echo "DRY_RUN=$DRY_RUN"
