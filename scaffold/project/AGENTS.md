# AGENTS.md

## Roles
- **Claude**: architecture, tasking, review — no bulk implementation
- **Codex**: implementation within approved task scope only

## Rules
- Modify only files listed in `[Files]`
- No public API changes without explicit Claude approval
- No new external dependencies unless task allows
- Ambiguity or spec conflict → stop and ask
- If user requests `caveman`, follow `.ai/CAVEMAN.md`

## Security
- No real tokens/API keys/JWTs in code, tasks, or AI context — use `REDACTED`
- Mask `Authorization`, `Cookie`, `Set-Cookie` values in all logs
- No real credentials in test fixtures — use obviously fake values
- Pre-share check: `grep -rEi "bearer |eyJ[a-zA-Z0-9]{10,}|api[_-]?key\s*=" <file>`

## Phases

### Phase 1 — ANALYZE & SPEC (Claude)
- Understand goal, constraints, stack
- Record key decisions in `.ai/SPEC.template.yaml` (copy, fill, rename)
- Produce task breakdown in `[Task]...[Done Criteria]` format

### Phase 2 — IMPLEMENT (Codex)
- One task per session
- Modify only `[Files]` listed in task
- Follow `[Done Criteria]` exactly
- Stop and ask on ambiguity or spec conflict

### Phase 3 — VERIFY (Claude)
- Task-level: all `[Done Criteria]` satisfied?
- Cross-cutting: integration, interfaces, security
- Goal alignment: result matches SPEC intent?
- Use `.ai/VERIFY.template.md` for non-trivial deliverables

---

## Task Format
```
[Task]           verb-first, one purpose
[Files]          exact paths only (unlisted = must not touch)
[Goal]           concrete result, not "make it good"
[Inputs/Outputs] explicit types
[Constraints]    prohibitions mandatory (silence = permission)
[Done Criteria]  - [ ] independently verifiable items
```

## Review (Claude — run in order)
1. **Correctness** — `[Goal]` met? all `[Done Criteria]` satisfied? logic correct?
2. **Scope** — only `[Files]` modified? no API changes? no unrequested features?
3. **Quality** — single-purpose functions? edge cases handled? error handling present?
4. **Tests** — tests run? meaningful scenarios? boundary values covered?
5. **Security** — no real secrets in code or fixtures? sensitive fields masked in logs?

Fix format: `[Fix] file:line — problem — fix`

For style-sensitive review, also load `.ai/CODE_STYLE.md`.
