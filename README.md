# Dotfiles

My dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

On a new machine:

```bash
# 1. Install chezmoi
brew install chezmoi  # macOS
# or
sudo apt install chezmoi  # Debian/Ubuntu
# or
sudo pacman -S chezmoi  # Arch Linux
# or
choco install chezmoi  # Windows

# 2. Apply this repository
chezmoi init https://github.com/JasonSMV/dotfiles.git
chezmoi apply
```

## Daily Usage

```bash
# Add a new file to chezmoi management
chezmoi add ~/.bashrc

# Re-add a file (after external modifications)
chezmoi re-add ~/.bashrc

# Edit a managed file
chezmoi edit ~/.bashrc

# Apply changes to your home directory
chezmoi apply

# Pull latest changes from repository and apply
chezmoi update

# View what would change without applying
chezmoi diff
```

## Managing Your Dotfiles

```bash
# Commit and push changes
cd $(chezmoi source-path)
git add .
git commit -m "Update dotfiles"
git push
```
