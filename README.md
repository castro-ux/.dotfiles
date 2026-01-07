# dotfiles

A minimal, portable dotfiles setup focused on **clarity, control, and portability**.

This repository contains my personal configuration files for Linux, organized to work with **manual symlinks** or **GNU Stow**. The goal is to make moving between machines painless while keeping configurations easy to understand and modify.

---

## Philosophy

- **Understand before you automate**
- Prefer simple, explicit symlinks
- Keep configs version controlled
- Allow an easy path to scale with GNU Stow

There are many dotfiles repos online. This one prioritizes learning how things work under the hood rather than blindly copying configurations.

---

## What Are Dotfiles?

Dotfiles are hidden configuration files used to customize your environment. They begin with a dot (`.`), which is why they don’t appear in a normal `ls` output.

Examples:
- `.bashrc`
- `.zshrc`
- `.gitconfig`
- `.tmux.conf`
- `~/.config/*`

---

## Repository Structure

This repo follows a **Stow-compatible layout**, even when using manual symlinks.

```text
~/.dotfiles/
├── bashrc/
│   └── .bashrc
├── hypr/
│   └── .config/
│       └── hypr/
│           ├── hyprland.conf
│           ├── hypridle.conf
│           ├── hyprpaper.conf
│           └── hyprlock.conf
└── scripts/
    └── install.sh
