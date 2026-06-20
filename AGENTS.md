# Dotfiles — Agent Reference

Managed with chezmoi v2.54+. Cross-platform: Windows (primary) + Linux (Arch/Omarchy).

**Real source is `home/`** — `.chezmoiroot` points chezmoi there. Everything at the repo root is ignored by chezmoi.

---

## Source → Destination Mapping

chezmoi decodes file names into target paths:

| Source prefix/suffix | Meaning |
|---|---|
| `dot_foo` | `.foo` |
| `foo.tmpl` | `foo` — rendered as Go template at apply time |
| `exact_dir/` | directory — chezmoi **deletes** any destination file not in source |
| `readonly_foo` | `foo` with write permissions stripped |
| `.chezmoitemplates/` | Partials — `{{ template "name" }}`, never deployed directly |
| `.chezmoidata/` | YAML/JSON auto-loaded as template variables |

---

## Key Files

```
home/
├── .chezmoi.toml.tmpl          # runs on init — prompts name/email/is_work, saves to chezmoi.toml
├── .chezmoidata/defaults.yaml  # static variable defaults (committed)
├── .chezmoiignore              # OS-conditional excludes
├── .chezmoitemplates/
│   ├── gitconfig               # ~130 lines of shared git settings
│   ├── gitignore               # global gitignore
│   ├── gittemplate             # commit message template
│   └── work-gitconfig          # work email override
├── dot_gitconfig.tmpl          → ~/.gitconfig          (Windows only)
├── dot_config/git/config.tmpl  → ~/.config/git/config  (Linux only)
├── dot_config/opencode/        → ~/.config/opencode/
├── dot_claude/                 → ~/.claude/
│   ├── exact_rules/            # behavior, code-style, git-conventions, workflow
│   └── exact_skills/commit/    # /commit slash command
├── dot_bashrc                  → ~/.bashrc              (Linux only)
├── AppData/                    → %APPDATA%              (Windows only)
└── dot_glzr/, dot_config/yasb/  (Windows only)
```

---

## Template Variables

Defined in `home/.chezmoidata/defaults.yaml` (static defaults) and overridden by `chezmoi init` prompts (saved to `~/.config/chezmoi/chezmoi.toml`).

| Variable | Default | Notes |
|---|---|---|
| `.name` | `Jeison Martinez` | |
| `.email` | `jeisonsmv@gmail.com` | personal |
| `.is_work` | `false` | gates work email + git includeIf |
| `.work_email` | `""` | prompted on init only when `is_work = true` |
| `.work_dir` | `TripArcRepos` | work repo directory name |
| `.company` | `trip-arc` | |
| `.chezmoi.os` | `linux` / `windows` | built-in, not in defaults.yaml |
| `.chezmoi.homeDir` | `/home/jason` | built-in, platform-aware |

**`.chezmoi.*` is NOT available inside `.chezmoitemplates/` partials** — only in outer `.tmpl` files.

Run `chezmoi data` to inspect all variables on the current machine.

---

## Cross-Platform

Windows-only files are excluded on Linux via the `{{ if ne .chezmoi.os "windows" }}` block in `home/.chezmoiignore`:
- `dot_gitconfig.tmpl`, `AppData/`, `dot_claude/settings.json`, `dot_glzr/glazewm/`, `dot_config/yasb/`

Git config uses two outer templates sharing one partial:
- Windows (`dot_gitconfig.tmpl`): `autocrlf = true`, `credential.helper = manager`
- Linux (`dot_config/git/config.tmpl`): `autocrlf = input`, no credential helper
- Both call `{{ template "gitconfig" }}` for the shared settings

---

## Never Commit

`.chezmoiignore` permanently excludes: `.credentials.json`, `history.jsonl`, `projects/**`, `sessions/**`, `telemetry/**`, `plugins/**`, `.npmrc` (Azure DevOps PAT), `antigravity-accounts.json`, `node_modules/**`, lockfiles.

---

## Workflow

```bash
# Edit source (not the deployed file)
nvim ~/.local/share/chezmoi/home/<file>

# Verify
chezmoi apply --force && chezmoi status  # status must be empty

# Commit and push
cd ~/.local/share/chezmoi
git add <files>
git commit -m "chore: 🧹 <description>"
git push https://JasonSMV:$(gh auth token)@github.com/JasonSMV/dotfiles.git HEAD:main
```

If you edited a deployed file directly instead of the source:
```bash
chezmoi re-add ~/.config/opencode/opencode.json
```

---

## Commit Format

`type: emoji description`. No ticket prefix for dotfiles changes.

`feat ✨` · `fix 🐛` · `refactor 🔨` · `chore 🧹` · `docs 📜` · `ci 📦`

---

## New Machine

**Windows:** `winget install twpayne.chezmoi` → `chezmoi init --apply https://github.com/JasonSMV/dotfiles.git`

**Linux:** `chezmoi init --apply https://github.com/JasonSMV/dotfiles.git` (chezmoi already installed via omarchy)

Prompts on init: Full name · Personal email · Is this a work machine? · Work email (if yes)
