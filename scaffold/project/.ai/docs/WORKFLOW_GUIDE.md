# WORKFLOW_GUIDE.md

Human-facing detailed process guide. AI agents do not need this file.

---

## New Project Setup

```bash
# Linux/Mac
bash /path/to/ai-dev-workspace/scripts/new-project.sh my-project

# Windows
.\new-project.ps1 my-project
```

Creates `my-project/` as a standalone repo with visible root files plus hidden `.ai/` support files.

Then:
1. Edit `PROJECT_CONTEXT.yaml` with project info
2. Start Claude Code session in the project folder — `CLAUDE.md` auto-loads context

---

## 3-Phase Workflow

```
Phase 1: ANALYZE & SPEC (Claude)
  → fill .ai/SPEC.template.yaml copy
  → produce tasks in TASK.template.md format

Phase 2: IMPLEMENT (Codex)
  → one task per session
  → strict file scope, stop on ambiguity

Phase 3: VERIFY (Claude)
  → fill .ai/VERIFY.template.md copy
  → check Done Criteria, cross-cutting, goal alignment
```

---

## Session Patterns

### Design session (Claude)

Use Plan Mode first (`Shift+Tab`), then:
```
@CODE_STYLE.md   ← only if reviewing code
[describe what to design]
```
`CLAUDE.md` already auto-loads `AGENTS.md`, `PROJECT_CONTEXT.yaml`, and `.ai/CAVEMAN.md`.

**Output to request:** module structure, interface spec, task breakdown in `[Task]...[Done Criteria]` format. Record design decisions in `.ai/SPEC.template.yaml` copy.

### Implementation (Codex)

Fill `TASK.template.md` and paste into Codex. See `docs/TASK_GUIDE.md` for examples.

Codex reads `AGENTS.md` and `PROJECT_CONTEXT.yaml` from the repo automatically.

### Verify session (Claude — Phase 3)

```
@.ai/CODE_STYLE.md
Verify Codex output. Follow AGENTS.md review checklist and fill .ai/VERIFY.template.md.

[original task]

[modified file contents — run security pre-check first]
```

Security pre-check before attaching files:
```bash
grep -rEi "bearer |eyJ[a-zA-Z0-9]{10,}|api[_-]?key\s*=" <files>
```

---

## Context Management (Claude Code)

- `/clear` between unrelated tasks — context fills fast
- After 2+ failed corrections: `/clear` and write a better initial prompt
- Rewind: `Esc+Esc` or `/rewind` to restore conversation/code state
- Long investigation? Say `"use a subagent to investigate X"` — keeps main context clean
- `claude --continue` to resume last session, `claude --resume` to pick session

---

## Recovery

**Codex output fails:**
1. Write specific `[Fix] file:line — problem — fix` items
2. Package as new task (original + fixes)
3. Re-deliver to Codex
4. 2+ failures → redesign, decompose smaller, re-deliver

**Requirements change mid-task:**
1. Stop Codex work
2. Update `PROJECT_CONTEXT.yaml`
3. Claude redesigns affected parts
4. New task → re-deliver

**Interface conflict:**
- Claude's interface definition always wins
- Request Codex to realign
- Update `PROJECT_CONTEXT.yaml`

---

## State Management

Update `PROJECT_CONTEXT.yaml` on: design complete, major impl done, architecture change, priority change.

Stale context → wrong tasks.
