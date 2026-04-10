# WORKFLOW_GUIDE.md

Human-facing process guide. AI agents do not need this file.

---

## New Project Setup

```bash
# Linux/Mac
bash /path/to/ai-dev-workspace/scripts/new-project.sh my-project

# Windows
.\new-project.ps1 my-project
```

Then:
1. Edit `PROJECT_CONTEXT.yaml`
2. Start Claude Code in the project folder — `CLAUDE.md` auto-loads context

---

## 5-Phase Workflow

```
Phase 0: BRIEF       (User)   — fill PROJECT_CONTEXT.yaml
Phase 1: DECOMPOSE   (Claude) — generate Epic → Stories → Tasks
Phase 2: REVIEW      (User)   — approve Stories, then Tasks
Phase 3: IMPLEMENT   (Codex)  — Claude auto-delegates via /codex:rescue
Phase 4: VERIFY      (Claude) — check Done Criteria, loop or advance
```

Claude usage is concentrated in Phases 1, 2, and 4.
Codex handles all implementation in Phase 3.

---

## Phase 0 — BRIEF

Fill `PROJECT_CONTEXT.yaml`:
- `project.purpose` — one sentence goal
- `stack` — language, framework, database, infra, test
- `constraints` — hard limits (performance, compliance, no external deps, etc.)
- `public_interfaces` — APIs Codex must not change without approval

---

## Phase 1 — DECOMPOSE (Claude)

Start Claude Code in the project folder. Say:

```
Analyze PROJECT_CONTEXT.yaml and decompose into Epic, Stories, and atomic Tasks.
```

Claude will generate:
- `.ai/EPIC.md` — overall goal + story list
- `.ai/stories/STORY-001.md`, `STORY-002.md`, … — one per feature area
- `.ai/tasks/TASK-001.md`, `TASK-002.md`, … — one per atomic unit of work

**Atomic Task sizing:**
- 1–3 files max
- One independently verifiable outcome
- Completable in a single Codex session (roughly 30 min equivalent)

---

## Phase 2 — REVIEW

### Story review
Read `.ai/stories/`. For each story:
- Scope correct?
- Priority right?
- Any missing stories?

Tell Claude to adjust, re-order, or split.

### Task review
Read `.ai/tasks/`. For each task:
- Files listed correctly?
- Done Criteria specific enough?
- Any task too large? (If yes, ask Claude to split)

Approve when ready.

---

## Phase 3 — IMPLEMENT

After Task approval, tell Claude:

```
Delegate TASK-001 to Codex.
```

Claude calls `/codex:rescue` with the full task content automatically.
Codex writes the code. Claude does not touch implementation files.

For background execution (non-blocking):
```
Delegate TASK-001 to Codex in background.
```

---

## Phase 4 — VERIFY

After Codex finishes, Claude reviews against:
- Task `[Done Criteria]`
- `AGENTS.md` review checklist
- `.ai/CODE_STYLE.md` (for style-sensitive review)

**Pass:** Claude marks Task done in `.ai/EPIC.md`, moves to next Task.

**Fail:** Claude writes `[Fix] file:line — problem — fix` items, creates a fix Task, delegates to Codex again.

---

## Iteration Pattern

```
For each approved Task:
  → /codex:rescue (Phase 3)
  → Claude verify (Phase 4)
  → pass? next Task : fix Task → repeat
```

After all Tasks in a Story pass:
- Claude marks Story `status: done` in `.ai/EPIC.md`
- Move to next Story

---

## Context Management

- `/clear` between unrelated tasks — context fills fast
- `claude --continue` to resume last session
- Long investigation? `"use a subagent to investigate X"` — keeps main context clean

---

## Recovery

**Codex output fails twice:**
1. Split the Task into smaller pieces
2. Claude rewrites `[Done Criteria]` to be more explicit
3. Re-delegate

**Requirements change mid-task:**
1. Stop Codex work
2. Update `PROJECT_CONTEXT.yaml`
3. Claude regenerates affected Stories/Tasks
4. Re-review, re-delegate

**Interface conflict:**
- Claude's interface definition always wins
- Request Codex to realign
- Update `public_interfaces` in `PROJECT_CONTEXT.yaml`

---

## File Map

| File | Owner | Purpose |
|------|-------|---------|
| `PROJECT_CONTEXT.yaml` | User | Project brief |
| `.ai/EPIC.md` | Claude | Goal + story/task status tracker |
| `.ai/stories/STORY-NNN.md` | Claude | Feature-level breakdown |
| `.ai/tasks/TASK-NNN.md` | Claude | Atomic Codex work unit |
| `.ai/templates/` | — | Blank templates for reference |
| `.ai/CODE_STYLE.md` | User/Claude | Style rules for review |
| `.ai/CAVEMAN.md` | — | Response mode config |
