#!/bin/bash
set -e

# --- TOGGLE THIS TO RUN ---
DRY_RUN=true #set to false to actually uninstall

# --- LOGGING ---
release_file=/etc/os-release
# logfile=/var/log/uninstaller.log
# errorlog=/var/log/uninstaller_errors.log

#Detect OS
if grep -qi "Arch" "$release";
then
	echo "This script is for Arch Linux only."
	exit 1
fi
echo "Arch LInux detected"


# -- PACKAGES TO REMOVE --
PACKAGES=(
	hyprland
	hyprpaper
	hypridle
	hyprlock stow
	ttf-jetbrains-mono-nerd 
	github-cli 
	tmux 
	neovim 
	libreoffice 
	tree 
	gimp 
	qutebrowser 
	zsh 
	git 
	unzip
	brave
)

# -- EXECUTE REMOVAL ---
if [ ${#PACKAGES[@]} -gt 0 ];
then
	echo "Removing packages.."
	run sudo pacman -Rns --noconfirm "${PACKAGES[@]}"
else
	echo "No packages to remove.."
fi

# -- CONFIG CLEANUP ---
echo "Removing user configs.."
run rm -rf ~/.config/hypr
run rm -rf ~/.oh-y-zsh
run rm -rf ~/.zshrc
run rm -rf ~/.local/share/fonts/JetBrainsMono*

# --- FONT CACHE ---
echo "Rebuilding font cache.."
run fc-cache -f
check_exit_status

# --- ORPHAN CLEANUP ---
echo "Removing orphaned packages.."
run sudo pacman -Rns --noconfirm \$(pacman -Qtdq || true)

echo "Uninstall Finished." 
echo "DRY_RUN=$DRY_RUN"

