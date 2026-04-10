# Task Guide — Atomic Task Writing

Human-facing guide. For blank template, see `.ai/templates/TASK.template.md`.

Claude generates Tasks automatically in Phase 1. This guide is for manual review and adjustment.

---

## Field Rules

- `[Task]`: verb-first, one line, one purpose only
- `[Story]`: parent STORY-NNN id
- `[Files]`: exact paths — 1–3 files max. Codex will not touch anything unlisted
- `[Goal]`: must say *what*, not "make it good"
- `[Inputs/Outputs]`: explicit types — "data" is not a type
- `[Constraints]`: prohibitions too — silence = permission
- `[Done Criteria]`: checkboxes only, each independently verifiable

SECURITY: Never paste real tokens/API keys/JWTs. Use REDACTED or fake values.

---

## Sizing Check

A Task is too large if any of these are true:
- Touches more than 3 files
- Has more than 5 Done Criteria items
- Requires understanding of more than one domain to verify
- Would take a senior dev more than ~30 min

Split it.

---

## Example 1: Token Refresh (good atomic size)

```text
[Task]
Implement token refresh logic

[Story]
STORY-001

[Files]
src/auth/token_manager.py
tests/test_token_manager.py

[Goal]
Automatically refresh token when less than 5 minutes remain before expiration.

[Inputs/Outputs]
input: current_token: str, expires_at: datetime
output: refreshed token string (str)

[Constraints]
- Do not change existing public function signatures
- Keep async behavior
- Mask token value in any log output
- Use fake tokens in tests only

[Done Criteria]
- [ ] refresh triggers when expires_at < now + 5min
- [ ] refresh does NOT trigger when > 5min remain
- [ ] token value masked in logs
- [ ] at least 3 unit tests with fake tokens
- [ ] type hints on all new functions
```

---

## Example 2: Database Repository

```text
[Task]
Add UserRepository with CRUD operations

[Story]
STORY-002

[Files]
src/db/user_repository.py
tests/test_user_repository.py

[Goal]
Implement create, read, update, delete for the User entity using SQLAlchemy ORM.

[Inputs/Outputs]
input (create): user_data: dict
input (read/update/delete): user_id: int
output: User object or None

[Constraints]
- Use SQLAlchemy ORM only — no raw SQL
- Return None for non-existent user_id (do not raise)
- Delete = soft delete via deleted_at column
- No new dependencies

[Done Criteria]
- [ ] all four CRUD methods exist
- [ ] non-existent user_id returns None (not exception)
- [ ] soft delete sets deleted_at, does not remove row
- [ ] at least 2 tests per method
- [ ] type hints included
```

---

## Example 3: API Endpoint

```text
[Task]
Add POST /api/v1/users endpoint

[Story]
STORY-003

[Files]
src/api/routes/users.py
tests/test_users_api.py

[Goal]
REST endpoint for creating a user. Returns 201 on success, 409 on duplicate email, 422 on validation error.

[Inputs/Outputs]
input:  { "email": str, "name": str, "role": "user"|"admin" }
output (201): { "id": int, "email": str, "name": str, "role": str, "created_at": ISO8601 }
output (409): duplicate email
output (422): missing/invalid field

[Constraints]
- Modify router file only — no service layer changes
- Use Pydantic for input validation
- Do not change existing routes

[Done Criteria]
- [ ] 201 on valid input
- [ ] 409 on duplicate email
- [ ] 422 on missing required field
- [ ] response schema matches spec above exactly
- [ ] test for each response code
```

---

## Bad Task Examples (too large — split these)

```text
# BAD: too many files, too many concerns
[Task]
Implement full authentication system

[Files]
src/auth/token_manager.py
src/auth/session.py
src/api/routes/auth.py
src/db/user_repository.py
tests/test_auth.py
tests/test_session.py
```

Split into: token refresh task + session task + auth routes task + user repo task.
