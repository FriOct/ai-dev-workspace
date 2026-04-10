# __PROJECT_NAME__

Standalone Claude Code + Codex collaboration project.

This folder is self-contained. You can keep working even if the original
`ai-dev-workspace` source folder is gone.

## Visible Files

- `CLAUDE.md` — Claude auto-load entrypoint
- `AGENTS.md` — shared rules for Claude and Codex
- `PROJECT_CONTEXT.yaml` — current project state and constraints
- `TASK.template.md` — task handoff template
- `.ai/` — hidden support docs, style guide, caveman mode

## Quick Start

1. Fill `PROJECT_CONTEXT.yaml`
2. Start Claude Code in this folder
3. Ask Claude to design or refine scope
4. Copy `TASK.template.md`, fill it out, and give it to Codex
5. Review results in Claude using `AGENTS.md` and `.ai/CODE_STYLE.md`

## Caveman Mode

Both Claude and Codex can use caveman mode in this repo.

Triggers:

- `caveman`
- `caveman mode`
- `talk like caveman`
- `be brief`
- `/caveman`

Rules live in `.ai/CAVEMAN.md`.

## Hidden Support Files

- `.ai/CODE_STYLE.md`
- `.ai/CAVEMAN.md`
- `.ai/SPEC.template.yaml` — Phase 1 design artifact (copy + fill per feature)
- `.ai/VERIFY.template.md` — Phase 3 verification checklist (copy + fill per delivery)
- `.ai/docs/TASK_GUIDE.md`
- `.ai/docs/WORKFLOW_GUIDE.md`
