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

## Cross-Platform Configuration

This dotfiles repository supports both **Windows** and **Linux** using chezmoi's template system.

### Why Cross-Platform?

Git config files are stored in different locations depending on the OS:

- **Linux/macOS**: `~/.config/git/config`
- **Windows**: `~/.gitconfig`

Additionally, some settings differ:

- Email addresses (personal vs work)
- Credential helper paths (`gh` location)

### File Structure

```
.chezmoitemplates/
    # Common templates - edit here for single-source updates
    gitconfig          # Common git settings (diff, colors, aliases, etc.)
    gitignore         # Common ignore rules (Python, Rust, Zig, etc.)
    gittemplate       # Common commit message template

# OS-specific destination files - these include the common templates
dot_gitconfig.tmpl         # Windows: ~/.gitconfig
dot_config/git/config.tmpl  # Linux: ~/.config/git/config

# These files go to the same location on both OS
dot_config/git/ignore.tmpl        # ~/.config/git/ignore
dot_config/git/template.txt.tmpl  # ~/.config/git/template.txt
```

### How It Works

1. **`.chezmoitemplates/`** contains the single source of truth for common config
   - Edit these files when you want changes on both Windows and Linux

2. **OS-specific files** (`dot_gitconfig.tmpl`, `dot_config/git/config.tmpl`)
   - Contain platform-specific settings (email, credential helper path)
   - Use `{{ template "gitconfig" }}` to include common settings from `.chezmoitemplates/`

3. **Shared destination files** (`ignore.tmpl`, `template.txt.tmpl`)
   - Same content on both OS (just copy to same location)
   - Use `{{ template "gitignore" }}` and `{{ template "gittemplate" }}` to include common templates

### Updating Common Settings

To update settings that apply to both platforms, edit the files in `.chezmoitemplates/`:

```bash
# Edit common git settings
chezmoi edit .chezmoitemplates/gitconfig

# Edit common gitignore
chezmoi edit .chezmoitemplates/gitignore

# Edit common commit template
chezmoi edit .chezmoitemplates/gittemplate
```
