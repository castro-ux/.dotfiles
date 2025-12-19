# Hyprland Dotfiles

Minimal Hyprland configuration focused on clarity, usability, and native Hypr ecosystem tools.

Includes configuration for:
- **Hyprland**
- **hyprlock**
- **hypridle**
- **hyprpaper**

Built for Arch Linux.

---

<p align="center">
  <img src="screenshots/desktop.png" width="900">
</p>

<p align="center">
  <img src="screenshots/lockscreen.png" width="900">
</p>

---

## About

These are my personal Hyprland dotfiles.

The goal is a **clean, keyboard-driven workflow** with minimal visual noise and light ricing.  
No plugins, no frameworks — just native Hyprland tools.

---

## Requirements

- Hyprland (Wayland)
- hyprlock
- hypridle
- hyprpaper

Optional:
- dmenu
- alacritty
- hyprshot

---

## Installation

Clone the repository and copy the configs into your Hyprland config directory.

Back up any existing config first.

Reload Hyprland or log out and back in after installing.

---

## Configuration Overview

```text
hyprland.conf    → main compositor config
hypridle.conf    → idle + autolock
hyprlock.conf    → lock screen
hyprpaper.conf  → wallpaper

---

## Requirements

```bash
sudo pacman -S hyprland hyprlock hypridle hyprpaper alacritty dmenu
yay -S hyprshot
