#!/bin/bash
set -e

# --- TOGGLE THIS TO RUN ---
DRY_RUN=false # Set to false to actually uninstall

# --- LOGGING ---
release_file=/etc/os-release

# --- DETECT OS ---
# Fixed: Added '!' (not) and changed $release to $release_file
if ! grep -qi "Arch" "$release_file"; then
    echo "This script is for Arch Linux only."
    exit 1
fi
echo "Arch Linux detected"

# --- PACKAGES TO REMOVE ---
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

# --- EXECUTE REMOVAL ---
echo "Removing packages.."
for PACKAGE in "${PACKAGES[@]}"; do
    # Check if package is installed
    if pacman -Qs "$PACKAGE" > /dev/null; then
        echo "Removing $PACKAGE..."
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] sudo pacman -Rns --noconfirm $PACKAGE"
        else
            sudo pacman -Rns --noconfirm "$PACKAGE"
        fi
    else
        echo "$PACKAGE not found, skipping..."
    fi
done

# --- CONFIG CLEANUP ---
echo "Removing user configs.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] rm -rf ~/.config/hypr ~/.oh-my-zsh ~/.zshrc ~/.local/share/fonts/JetBrainsMono*"
else
    rm -rf ~/.config/hypr
    rm -rf ~/.oh-my-zsh
    rm -rf ~/.zshrc
    rm -rf ~/.local/share/fonts/JetBrainsMono*
fi


# --- ORPHAN CLEANUP ---
echo "Removing orphaned packages.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] sudo pacman -Rns --noconfirm \$(pacman -Qtdq)"
else
    # Uses || true so the script doesn't crash if there are no orphans
    sudo pacman -Rns --noconfirm $(pacman -Qtdq) || true
fi

echo "Uninstall Finished." 
echo "DRY_RUN=$DRY_RUN"
