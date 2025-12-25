#!/bin/bash
set -e

# --- TOGGLE THIS TO RUN ---
DRY_RUN=false  # Set to false to actually install

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
)

# --- CHECK IF PACKAGES ARE INSTALLED ---
echo "Checking installed packages..."
for package in "${PACKAGES[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        echo "Package '$package' is already installed. Skipping."
    else
        echo "Package '$package' is not installed. Will install."
        packages_to_install+=("$package")
    fi
done

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
    echo "[DRY-RUN] mkdir -p ~/.config/hypr ~/.oh-my-zsh ~/.local/share/fonts/JetBrainsMono && cp -rf ~/.dotfiles/* ~/.config/*"
    echo "[DRY-RUN] stow --ignore='README.md' hypr"
    echo "[DRY-RUN] stow --ignore='README.md' alacritty"
else
    # Actual actions (without DRY-RUN)
    mkdir -p ~/.config/hypr ~/.oh-my-zsh ~/.local/share/fonts/JetBrainsMono
    #cp -rf ~/.dotfiles/hypr ~/.config/hypr
    #cp -rf ~/.dotfiles/alacritty ~/.config/alacritty
    
    # Use stow with --ignore to prevent README.md files from being stowed
    stow --ignore='README.md' hypr
    stow --ignore='README.md' alacritty
fi


# --- FONT CACHE ---
echo "Rebuilding font cache.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] fc-cache -f"
else
    fc-cache -f
fi

# --- CONFIGURATION SETUP ---
echo "Setting up user configs.."
if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] mkdir -p ~/.config/hypr ~/.oh-my-zsh ~/.local/share/fonts/JetBrainsMono && cp -rf ~/.dotfiles/* ~/.config/*"
    echo "[DRY-RUN] stow hypr"
    echo "[DRY-RUN] stow alacritty"
else
    # Actual actions (without DRY-RUN)
    mkdir -p ~/.config/hypr ~/.oh-my-zsh ~/.local/share/fonts/JetBrainsMono
    cp -rf ~/.dotfiles/hypr/.config/. ~/.config/hypr
    cp -rf ~/.dotfiles/alacritty/.config/. ~/.config/alacritty
    stow hypr
    stow alacritty
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
