# Design: Claude Code AI Config Improvements

**Date:** 2026-06-04
**Status:** Approved
**Scope:** Rules split + `/commit` skill

---

## Background

Current `~/.claude/` has 3 files: `CLAUDE.md` (76 lines, mixed concerns), `RTK.md`, `settings.json`.
Inspired by guicaulada/dotfiles audit. Dropping: status line (Windows porting cost), damage control (user doesn't want it).

---

## 1. Rules Split

### Goal
Extract behavioral rules out of `CLAUDE.md` into `~/.claude/rules/` files that Claude reads automatically. CLAUDE.md becomes a thin persona shell.

### Structure

```
home/dot_claude/
  CLAUDE.md                          ← thin: persona summary + @RTK.md only
  exact_rules/
    git-conventions.md               ← commit format, ticket prefix, type/emoji table
    workflow.md                      ← interaction rules (stop-and-wait, verify, alternatives)
    behavior.md                      ← personality, tone, philosophy, push-back rules
    code-style.md                    ← C#/.NET/Angular placeholder, grows over time
```

Deploys via chezmoi `exact_rules/` prefix → `~/.claude/rules/` (exact match, no extra files).

### CLAUDE.md after extraction

```markdown
# Jeison Martinez — Senior Architect

C#, .NET, Angular, 15+ years. GDE & MVP. Direct, no filter. Goal: make people learn, not be liked.

@RTK.md
```

All rules live in `rules/` files. No duplication.

---

## 2. `/commit` Skill

### Goal
Analyze staged diff, infer commit type, extract ticket from branch, propose message in house format, confirm and commit.

### Location
`home/dot_claude/exact_skills/commit/SKILL.md` → `~/.claude/skills/commit/SKILL.md`

### Format
```
[TICKET-ID] type: emoji description
```
Ticket omitted when branch has no `[A-Z]+-\d+` match.

### Flow
1. Check staged changes exist (`git diff --staged --stat`) — error if nothing staged
2. Read full diff (`git diff --staged`)
3. Extract ticket from branch name via `[A-Z]+-\d+` regex
4. Infer type from diff:
   - New files / new exported symbols → `feat ✨`
   - Fix/bug/null/error keywords in changed lines → `fix 🐛`
   - Rename / restructure without behavior change → `refactor 🔨`
   - Tests only → `test 🚦`
   - CI/config/tooling → `chore 🧹`
   - Docs only → `docs 📜`
5. Write a short imperative description (≤50 chars after prefix)
6. Display proposal, wait for confirmation or typed override
7. Run `git commit -m "..."`

### Edge cases
| Case | Behavior |
|------|----------|
| Nothing staged | Error: "Nothing staged. Run `git add` first." |
| No ticket in branch | Omit prefix silently |
| Ambiguous type | Pick most likely, note it: "inferred `feat` — correct if wrong" |
| Multi-concern diff | Split suggestion: "This touches 3 concerns — consider splitting into separate commits" |

---

## Out of Scope
- Status line (Windows porting cost not worth it)
- Damage control hook (user declined)
- `/create-pr` skill (future)
- `/triage` skill (future)
