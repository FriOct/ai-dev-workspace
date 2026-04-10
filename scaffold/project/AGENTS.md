# AGENTS.md

## Roles
- **Claude**: decompose, design, delegate, verify — no implementation
- **Codex**: implement atomic tasks only, strict file scope

## Codex Delegation Rule
After user approves a Task, Claude MUST delegate via `/codex:rescue`.
Claude does NOT write implementation code.
One Task per Codex run — never batch multiple Tasks.

---

## Phases

### Phase 0 — BRIEF (User)
- Fill `PROJECT_CONTEXT.yaml` with purpose, stack, constraints

### Phase 1 — DECOMPOSE (Claude)
1. Read `PROJECT_CONTEXT.yaml`
2. Generate `.ai/EPIC.md` — overall goal + story list
3. Generate `.ai/stories/STORY-NNN.md` per story
4. Generate `.ai/tasks/TASK-NNN.md` per atomic task

**Atomic Task criteria:**
- 1–3 files max
- One independently verifiable outcome
- No hidden dependency on another in-progress Task
- Completable in a single Codex session

### Phase 2 — REVIEW (User + Claude)
- User reviews Story list → adjust scope/priority
- User reviews Task list → approve, edit, or reject each
- Claude updates files per feedback, regenerates if needed

### Phase 3 — IMPLEMENT (Codex via Claude)
- Claude calls `/codex:rescue` with full Task content
- Claude does not touch implementation files
- Wait for Codex output, then proceed to Phase 4

### Phase 4 — VERIFY (Claude)
- Check all `[Done Criteria]` items
- Cross-cutting: scope, interfaces, security
- Pass → mark Task done in `EPIC.md`, move to next Task
- Fail → write `[Fix]` items, create new fix Task, back to Phase 3

---

## Task Format
```
[Task]           verb-first, one purpose
[Story]          parent STORY-NNN
[Files]          exact paths only, 1–3 files (unlisted = must not touch)
[Goal]           concrete result, not "make it good"
[Inputs/Outputs] explicit types
[Constraints]    prohibitions mandatory (silence = permission)
[Done Criteria]  - [ ] independently verifiable items
```

## Epic Format
```
# Epic: <name>
goal: <one sentence>
stories:
  - id: STORY-001
    title: <title>
    status: pending | in-progress | done
    tasks: [TASK-001, TASK-002]
```

## Story Format
```
# Story: <title>
id: STORY-NNN
goal: as a <user>, I want <goal> so that <value>
acceptance: what "done" looks like at story level
tasks:
  - TASK-NNN: <one-line summary>
```

---

## Review Checklist (Phase 4 — run in order)
1. **Correctness** — `[Goal]` met? all `[Done Criteria]` satisfied?
2. **Scope** — only `[Files]` modified? no API changes? no unrequested features?
3. **Quality** — single-purpose functions? edge cases handled?
4. **Tests** — tests pass? meaningful scenarios? boundary values covered?
5. **Security** — no real secrets? sensitive fields masked in logs?

Fix format: `[Fix] file:line — problem — fix`

For style review, load `.ai/CODE_STYLE.md`.

---

## Rules
- Modify only files listed in `[Files]`
- No public API changes without explicit Claude approval
- No new external dependencies unless Task allows
- Ambiguity or spec conflict → stop and ask

## Security
- No real tokens/API keys/JWTs in code, tasks, or AI context — use `REDACTED`
- Mask `Authorization`, `Cookie`, `Set-Cookie` values in all logs
- No real credentials in test fixtures — use obviously fake values
- Pre-share check: `grep -rEi "bearer |eyJ[a-zA-Z0-9]{10,}|api[_-]?key\s*=" <file>`

## Caveman
If user requests caveman mode, follow `.ai/CAVEMAN.md`.
