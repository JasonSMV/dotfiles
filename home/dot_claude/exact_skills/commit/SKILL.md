# /commit

Analyze staged changes and create a commit message following the house format.

## Format

```
[TICKET-ID] type: emoji description
```

Ticket prefix only when branch contains a Jira-style ID (e.g. `KT-11202`).

## Steps

1. Check staged changes exist with `git diff --staged --stat`
   - If nothing staged: stop with "Nothing staged. Run `git add` first."

2. Read the full diff with `git diff --staged`

3. Extract ticket ID from current branch name:
   - Run `git branch --show-current`
   - Match regex `[A-Z]+-\d+` (e.g. `feature/KT-11202-trip-filter` → `KT-11202`)
   - If no match: omit prefix silently

4. Infer commit type from the diff:
   - New files / new exported symbols → `feat ✨`
   - Bug/fix/null/error corrections → `fix 🐛`
   - Rename / restructure without behavior change → `refactor 🔨`
   - Tests only → `test 🚦`
   - CI / config / tooling → `chore 🧹`
   - Docs only → `docs 📜`
   - If ambiguous: pick most likely and note it

5. Write a short imperative description (≤50 chars after prefix)

6. Display the proposed message:
   ```
   Proposed commit:
   KT-11202 feat: ✨ add trip filter

   Confirm? (Enter to accept, or type override)
   ```

7. Wait for input:
   - Enter with no input → run `git commit -m "<proposed>"`
   - Typed override → run `git commit -m "<override>"`

## Notes

- NEVER add Co-Authored-By or AI attribution
- If diff touches 3+ unrelated concerns, suggest splitting before committing
- Description must be imperative mood: "add", "fix", "remove" — not "added", "fixes", "removing"
