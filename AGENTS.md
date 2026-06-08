# Dotfiles Agent Guide

Jeison Martinez's dotfiles — managed with [chezmoi](https://www.chezmoi.io/) v2.54+.
Cross-platform: Windows (primary) + Linux (Arch/Omarchy).

---

## Repo Structure

```
dotfiles/
├── AGENTS.md              ← you are here (not read by chezmoi)
├── .chezmoiroot           ← contains "home" — tells chezmoi the real source is home/
├── .chezmoiversion        ← minimum chezmoi version required (2.54.0)
├── .editorconfig
├── NEW-MACHINE.md         ← human setup guide for a new Windows machine
├── README.md
├── packages/              ← winget package bundles (Windows only, manual)
└── home/                  ← THE REAL SOURCE DIRECTORY (chezmoi reads from here)
    ├── .chezmoi.toml.tmpl         ← machine config template (runs on chezmoi init)
    ├── .chezmoidata/
    │   └── defaults.yaml          ← static template variable defaults
    ├── .chezmoiignore             ← OS-conditional file exclusions
    ├── .chezmoitemplates/
    │   ├── gitconfig              ← shared git config (130 lines of opinionated settings)
    │   ├── gitignore              ← shared global gitignore
    │   ├── gittemplate            ← commit message template (conventional commits + emojis)
    │   └── work-gitconfig         ← work machine email override
    ├── dot_bashrc                 → ~/.bashrc (Linux)
    ├── dot_gitconfig.tmpl         → ~/.gitconfig (Windows only, ignored on Linux)
    ├── dot_ideavimrc              → ~/.ideavimrc (IdeaVim for Rider)
    ├── dot_config/
    │   ├── git/
    │   │   ├── config.tmpl        → ~/.config/git/config (Linux only)
    │   │   ├── ignore.tmpl        → ~/.config/git/ignore
    │   │   └── template.txt.tmpl  → ~/.config/git/template.txt
    │   ├── fastfetch/             → ~/.config/fastfetch/
    │   ├── mpv/                   → ~/.config/mpv/
    │   └── opencode/              → ~/.config/opencode/
    │       ├── opencode.json      ← main OpenCode config (MCPs, providers, plugins)
    │       ├── settings.json      ← OpenCode UI settings
    │       ├── package.json       ← declares @opencode-ai/plugin dependency
    │       ├── agents/            ← OpenCode named subagents
    │       │   └── JiraAnalysis.md
    │       ├── plugins/
    │       │   └── rtk.ts         ← RTK plugin (rewrites tool calls for token savings)
    │       └── profiles/          ← named MCP profiles (activate with --profile)
    │           ├── azure-devops-work.json
    │           ├── azure-infra.json
    │           └── jira-confluence.json
    ├── dot_claude/                → ~/.claude/
    │   ├── CLAUDE.md              ← global AI persona + @RTK.md reference
    │   ├── RTK.md                 ← RTK tool reference injected into every session
    │   ├── settings.json          ← Claude Code hooks + plugins (Windows only)
    │   ├── exact_rules/           ← behavior, code-style, git-conventions, workflow rules
    │   └── exact_skills/commit/   ← /commit slash command skill
    ├── AppData/                   → Windows %APPDATA% (Windows only, ignored on Linux)
    │   ├── Local/.../WindowsTerminal/settings.json
    │   └── Roaming/
    │       ├── Code/User/settings.json   ← VS Code settings
    │       └── opencode/                 ← OpenCode Windows config
    │           ├── AGENTS.md             ← Windows-side agent guide (same role as this file)
    │           ├── commands/             ← caveman slash commands
    │           └── plugins/caveman/      ← caveman plugin
    ├── dot_glzr/glazewm/          → ~/.glzr/glazewm/ (Windows only)
    ├── dot_config/whkdrc          → ~/.config/whkdrc (Windows only)
    ├── dot_config/yasb/           → ~/.config/yasb/ (Windows only)
    ├── komorebi.json              → ~/komorebi.json (Windows only)
    ├── komorebi.bar.json          → ~/komorebi.bar.json (Windows only)
    └── komorebi.bar.monitor2.json → ~/komorebi.bar.monitor2.json (Windows only)
```

**Critical:** Everything outside `home/` is ignored by chezmoi. Never edit files at the repo root expecting chezmoi to pick them up — they won't be applied.

---

## Chezmoi Naming Conventions

Chezmoi encodes target behavior in source file names. Know these before touching any file:

| Source name | Target name / meaning |
|---|---|
| `dot_foo` | `.foo` (adds leading dot) |
| `dot_config/` | `.config/` |
| `foo.tmpl` | `foo` (file is a Go template, rendered at apply time) |
| `dot_foo.tmpl` | `.foo` (dot + template) |
| `exact_rules/` | `rules/` — chezmoi **removes** any files in the destination not present in the source |
| `readonly_foo` | `foo` with write permissions stripped |
| `executable_foo` | `foo` with execute permissions added |
| `private_foo` | `foo` with group/world permissions removed |
| `.chezmoitemplates/` | Template partials — referenced with `{{ template "name" }}`, not deployed directly |
| `.chezmoidata/` | YAML/JSON files auto-loaded as template variables |
| `.chezmoiignore` | Gitignore-style exclusions, supports Go templates |
| `.chezmoi.toml.tmpl` | Generates `~/.config/chezmoi/chezmoi.toml` on first `chezmoi init` |

**`exact_` prefix is destructive.** The `exact_rules/` directory under `dot_claude/` means chezmoi will delete any file in `~/.claude/rules/` that isn't tracked here. Don't add untracked files to that directory on any machine.

---

## Template Variables

Templates use Go's `text/template` syntax. `missingkey=error` is enforced — every variable referenced in a `.tmpl` file must exist or `chezmoi apply` fails.

### Built-in `.chezmoi.*` variables (always available)

| Variable | Example value |
|---|---|
| `.chezmoi.os` | `"windows"` or `"linux"` |
| `.chezmoi.homeDir` | `C:\Users\devje` or `/home/jason` |
| `.chezmoi.hostname` | `DESKTOP-XYZ` or `omarchy` |
| `.chezmoi.username` | `devje` or `jason` |
| `.chezmoi.arch` | `"amd64"` |

Use `.chezmoi.os` for OS conditionals in templates. **`.chezmoi.*` is NOT available inside `.chezmoitemplates/` partials** — only in outer `.tmpl` files. If a partial needs OS info, pass it via a user variable or move the conditional to the outer template.

### User-defined variables

Two sources, merged in order (`.chezmoi.toml.tmpl` output wins over `defaults.yaml`):

**`home/.chezmoidata/defaults.yaml`** — static defaults committed to the repo:
```yaml
name: Jeison Martinez
email: jeisonsmv@gmail.com
is_work: false
company: trip-arc
work_dir: TripArcRepos
git:
  default_branch: main
```

**`home/.chezmoi.toml.tmpl`** — interactive prompts on `chezmoi init` (answers saved to `~/.config/chezmoi/chezmoi.toml`, override defaults):
```
name        ← full name
email       ← personal email
is_work     ← bool: is this a work machine?
work_email  ← prompted only when is_work = true
```

**Using variables in templates:**
```
{{ .name }}                                          → Jeison Martinez
{{ .email }}                                         → jeisonsmv@gmail.com
{{ if .is_work }}{{ .work_email }}{{ else }}{{ .email }}{{ end }}
{{ if .is_work }}[includeIf "gitdir:~/{{ .work_dir }}/"]{{ end }}
{{ .chezmoi.homeDir }}                               → platform-aware home path
```

To inspect what variables chezmoi currently sees on the machine:
```bash
chezmoi data
```

---

## Cross-Platform Rules

### What runs where

| Config | Windows | Linux |
|---|---|---|
| `dot_gitconfig.tmpl` → `~/.gitconfig` | yes | **no** (ignored) |
| `dot_config/git/config.tmpl` → `~/.config/git/config` | **no** (XDG not primary on Win) | yes |
| `AppData/` → `%APPDATA%` / `%LOCALAPPDATA%` | yes | **no** (ignored) |
| `dot_claude/settings.json` → `~/.claude/settings.json` | yes | **no** (Windows paths inside) |
| `komorebi.json`, `komorebi.bar*.json` | yes | **no** |
| `dot_config/yasb/`, `dot_config/whkdrc` | yes | **no** |
| `dot_glzr/glazewm/` | yes | **no** |
| `dot_bashrc` → `~/.bashrc` | **no** (no bash on Win) | yes |
| `dot_config/mpv/`, `dot_config/fastfetch/` | yes | yes |
| `dot_config/opencode/` → `~/.config/opencode/` | yes | yes |
| `dot_claude/CLAUDE.md`, `RTK.md`, `exact_rules/`, `exact_skills/` | yes | yes |
| `dot_ideavimrc` → `~/.ideavimrc` | yes | yes |

Platform guards live in `home/.chezmoiignore`. The pattern is:
```
{{ if ne .chezmoi.os "windows" }}
# list of files to skip on non-Windows
{{ end }}
```

### Adding a new Windows-only file

1. Add the source file under `home/` with the correct `dot_` prefix.
2. Add its source path to the `{{ if ne .chezmoi.os "windows" }}` block in `home/.chezmoiignore`.
3. Test: `chezmoi apply --dry-run` on Linux should not show it.

### Adding a new Linux-only file

1. Add the source file under `home/`.
2. Add its source path to the `{{ if eq .chezmoi.os "windows" }}` block in `.chezmoiignore` (create this block if it doesn't exist).

---

## Git Config Architecture

Two templates render a git config, both sharing one large partial:

```
dot_gitconfig.tmpl          (Windows → ~/.gitconfig)
dot_config/git/config.tmpl  (Linux → ~/.config/git/config)
         ↓ both call
{{ template "gitconfig" }}  (.chezmoitemplates/gitconfig)
```

The shared `gitconfig` partial contains ~130 lines of settings (diff, push, pull, rebase, colors, rerere, etc.). The outer templates add what's OS-specific:

- **Windows** adds `autocrlf = true` and `[credential] helper = manager`
- **Linux** adds `autocrlf = input`

**Work machine git:** When `is_work = true`, both outer templates emit:
```ini
[includeIf "gitdir:~/TripArcRepos/"]
    path = ~/TripArcRepos/.gitconfig
```
That `.gitconfig` must exist in the work repo root and contain the work email override (see `.chezmoitemplates/work-gitconfig`).

**Commit template** (`gittemplate` partial) and **global gitignore** (`gitignore` partial) are deployed via:
```
dot_config/git/template.txt.tmpl → {{ template "gittemplate" }}
dot_config/git/ignore.tmpl       → {{ template "gitignore" }}
```

---

## OpenCode Config

**Source:** `home/dot_config/opencode/` → `~/.config/opencode/`  
**Windows source:** `home/AppData/Roaming/opencode/` → `%APPDATA%\opencode\`

### opencode.json

Main config. Contains:
- `mcp` — MCP server definitions (Docker MCP enabled by default; Azure DevOps disabled by default, enabled via profiles)
- `provider.google` — custom model definitions for Gemini 3 Pro/Flash, Claude Sonnet/Opus thinking variants
- `plugin` — three plugins always loaded:
  1. `opencode-antigravity-auth@latest` — auth plugin
  2. `superpowers@git+https://github.com/obra/superpowers.git` — skills framework
  3. `./plugins/rtk.ts` — local RTK token-saving plugin

**When adding an MCP server:** edit `opencode.json`, set `enabled: true/false` as appropriate. If it's a work-only server, consider adding it to a profile instead of the base config.

### Profiles

Activate with `opencode --profile <name>`. Each profile merges its MCP config on top of `opencode.json`.

| Profile | Purpose |
|---|---|
| `azure-devops-work` | Enables Azure DevOps MCP for `trip-arc` org |
| `azure-infra` | Docker MCP gateway (infra/DevOps tasks) |
| `jira-confluence` | Docker MCP + Azure DevOps (full work stack) |

### plugins/rtk.ts

Intercepts every tool call via `tool.execute.before`. Delegates to `rtk rewrite` (Rust binary). If `rtk` is not in PATH the plugin disables itself silently — it is safe to deploy on machines without RTK.

### Agents

Named subagents under `agents/`. Currently: `JiraAnalysis.md` — analyzes Jira tickets and estimates story points. Invoked via `@JiraAnalysis` in an OpenCode session.

---

## Claude Code Config

**Source:** `home/dot_claude/` → `~/.claude/`

### CLAUDE.md

Global persona: Senior Architect, C#/.NET/Angular, 15+ years, GDE & MVP. Direct, no filter. References `@RTK.md` to inject RTK tool usage into every session.

### exact_rules/ (deployed with `exact_` prefix — destructive)

Four rule files always injected:
- `behavior.md` — persona, tone, philosophy
- `code-style.md` — C#/.NET, Angular/TypeScript conventions
- `git-conventions.md` — commit format: `[TICKET-ID] type: emoji description`
- `workflow.md` — verify before asserting, never assume, push back

**Do not add untracked files to `~/.claude/rules/` directly** — `exact_` means chezmoi will delete them on next apply.

### exact_skills/commit/SKILL.md

The `/commit` slash command. Analyzes staged diff, extracts ticket ID from branch name, proposes a commit message in the house format. Waits for confirmation before committing. Never adds Co-Authored-By.

### settings.json (Windows only)

Claude Code hooks:
- `PreToolUse/Bash` → `rtk hook claude` (rewrites shell commands for token savings)
- `SessionStart` + `UserPromptSubmit` → caveman plugin hooks (Windows node.js paths — do not deploy on Linux)

This file is excluded on Linux via `.chezmoiignore`.

---

## Never Track These

The following are permanently excluded in `home/.chezmoiignore` regardless of OS:

| Path | Reason |
|---|---|
| `dot_claude/.credentials.json` | Auth tokens |
| `dot_claude/history.jsonl` | Session history |
| `dot_claude/projects/**` | Per-project state |
| `dot_claude/sessions/**` | Session state |
| `dot_claude/telemetry/**` | Telemetry data |
| `dot_claude/plugins/**` | Installed plugins (not source-controlled) |
| `dot_npmrc` | Contains Azure DevOps PAT token |
| `dot_config/opencode/antigravity-accounts.json` | Auth accounts |
| `dot_config/opencode/bun.lock` | Lockfile (auto-generated) |
| `dot_config/opencode/node_modules/**` | Dependencies |
| `AppData/Roaming/opencode/antigravity-accounts.json` | Auth accounts (Windows) |
| `AppData/Roaming/opencode/node_modules/**` | Dependencies (Windows) |

**Never add secrets, tokens, or auth files to this repo.**

---

## Workflow: Making Changes

### The correct edit loop

```bash
# 1. Edit the SOURCE file (in the chezmoi source dir, not the deployed file)
nvim ~/.local/share/chezmoi/home/dot_config/opencode/opencode.json

# 2. Apply to verify it renders and deploys correctly
chezmoi apply --force

# 3. Verify no drift remains
chezmoi status   # should be empty

# 4. Stage and commit
cd ~/.local/share/chezmoi
git add <files>
git commit -m "chore: 🧹 description"

# 5. Push (Linux — credential-manager not installed, use gh token)
git push https://JasonSMV:$(gh auth token)@github.com/JasonSMV/dotfiles.git HEAD:main
```

### Editing a deployed file directly (wrong way)

If you edit `~/.config/opencode/opencode.json` directly instead of the source, use `chezmoi re-add` to sync the change back:
```bash
chezmoi re-add ~/.config/opencode/opencode.json
```
Then verify with `chezmoi diff` (should be empty) and commit.

### Editing a template file

For `.tmpl` files, preview the rendered output before applying:
```bash
chezmoi cat ~/.config/git/config      # shows what chezmoi would write
chezmoi diff                          # shows diff vs current deployed state
chezmoi execute-template < home/dot_config/git/config.tmpl   # render manually
```

### Adding a new file to track

```bash
chezmoi add ~/.config/someapp/config.json
# chezmoi creates home/dot_config/someapp/config.json in the source dir
# Then commit it
```

### Checking what chezmoi manages

```bash
chezmoi managed          # list all managed files
chezmoi ignored          # list all ignored files (what .chezmoiignore excludes)
chezmoi status           # show any drift between source and destination
chezmoi data             # dump all template variables
```

---

## Commit Convention

Format: `[TICKET-ID] type: emoji description`

Ticket prefix only when relevant. Omit for dotfiles changes.

| Type | Emoji | Use for |
|---|---|---|
| `feat` | ✨ | New config, new tool added |
| `fix` | 🐛 | Broken config, wrong value |
| `refactor` | 🔨 | Restructure without behavior change |
| `chore` | 🧹 | Sync drift, update versions |
| `docs` | 📜 | README, AGENTS.md, comments |
| `ci` | 📦 | GitHub Actions workflow changes |

Examples:
```
chore: 🧹 remove drawio MCP from opencode.json
fix: 🐛 suppress credential-manager warning on Linux
feat: ✨ add JiraAnalysis agent
```

---

## New Machine Setup (Quick Reference)

**Windows:**
```powershell
winget install Git.Git
winget install twpayne.chezmoi
chezmoi init --apply https://github.com/JasonSMV/dotfiles.git
# chezmoi will prompt: Full name, Personal email, Is this a work machine?, Work email (if yes)
```

**Linux (Arch/Omarchy):**
```bash
# chezmoi is already installed via omarchy
chezmoi init --apply https://github.com/JasonSMV/dotfiles.git
```

See `NEW-MACHINE.md` for the full Windows setup guide including winget packages, manual configs, and tool installations.
