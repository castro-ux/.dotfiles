!/bin/bash

# --- TOGGLE THIS TO RUN ---
TEST_MODE=false # Set to false to actually perform the uninstall
# --------------------------

# 1. Detect Package Manager
if command -v pacman &> /dev/null;
then
distro_cmd="pacman"
pkg_rm="sudo pacman -Rns --noconfirm"

elif command -v apt &> /dev/null; 
then
distro_cmd="apt"
pkg_rm="sudo apt purge -y"

elif command -v apk &> /dev/null; 
then
distro_cmd="apk"
pkg_rm="sudo apk del"
fi

# 2. Define the Cleanup Actions
CLEANUP_COMMANDS=(
"sudo chsh -s $(which bash) $USER"
"$pkg_rm hyprland ttf-jetbrains-mono-nerd github-cli tmux neovim libreoffice tree gimp qutebrowser zsh git unzip"
"rm -rf $HOME/.oh-my-zsh $HOME/.zshrc $HOME/.local/share/fonts/JetBrainsMono*"
"fc-cache -f"
)

# 3. Remove Hyprland Specifics
if [ "$distro_cmd" = "pacman" ]; then
CLEANUP_COMMANDS+=(
"$pkg_rm hyprland hyprlock hyprpaper hypridle stow"
"rm -rf $HOME/.config/hypr $HOME/.cache/hyprland $HOME/.local/share/hyprland $HOME/.dotfiles"
"pacman -Qs hypr && echo 'success hyprland fully uninstalled'"
)
fi

# 4. Confirmation Logic
if [  "$TEST_MODE" = false ]; 
then
	echo "!!! WARNING!!!"
	echo "You're about to uninstall all your dotfiles and configurations."
	echo "The following commands will be executed:"
	for cmd in "${CLEANUP_COMMANDS[ @ ]}"; do echo
		"  -> $cmd"; done

	echo -n "Are you absolutely sure you want to proceed? (type 'yes' to continue): "
	read -r confirmation
	if [  "$confirmation" != "yes"  ]; then 
		echo "Uninstall ancelled."
		exit 0
	fi
fi

# 5. The Execution Loop
echo "--- UNINSTALL LOG (Test Mode: $TEST_MODE) ---"

for cmd in "${CLEANUP_COMMANDS[@]}"; 
do
if [ "$TEST_MODE" = true ]; 
then
echo "[WILL RUN]: $cmd"
else
echo "[EXECUTING]: $cmd"
eval "$cmd"
fi
done

echo "--- Finished ---"
