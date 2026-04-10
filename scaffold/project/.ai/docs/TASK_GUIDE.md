# Task Guide — Examples & Field Writing

Human-facing guide. For actual task handoff, use TASK.template.md.

---

## Field Rules

- `[Task]`: verb-first, one line, one purpose only
- `[Files]`: exact paths — Codex will not touch anything unlisted
- `[Goal]`: must say *what*, not "make it good"
- `[Inputs/Outputs]`: explicit types — "data" is not a type
- `[Constraints]`: prohibitions too — silence = permission
- `[Done Criteria]`: checkboxes only, each independently verifiable

SECURITY: Never paste real tokens/API keys/JWTs. Use REDACTED or fake values.

---

## Example 1: Token Refresh

```text
[Task]
Implement refresh token handling

[Files]
src/auth/token_manager.py
tests/test_token_manager.py

[Goal]
Automatically refresh token when less than 5 minutes remain before expiration.

[Inputs/Outputs]
input: current_token: str, expires_at: datetime
output: refreshed token string (str)

[Constraints]
- Do not change existing public API signatures
- Keep async behavior
- Add logging (mask token value in logs)
- Add tests (fake tokens only)

[Done Criteria]
- [ ] At least 3 unit tests
- [ ] Type hints included
- [ ] Error handling included
- [ ] Expiry logic triggers at < 5 min threshold exactly
```

---

## Example 2: Database Repository

```text
[Task]
Add UserRepository with CRUD operations

[Files]
src/db/user_repository.py
tests/test_user_repository.py

[Goal]
Implement create, read, update, delete methods for the User entity.

[Inputs/Outputs]
input (create): user_data: dict
input (read): user_id: int
input (update): user_id: int, update_data: dict
input (delete): user_id: int
output: User object or None

[Constraints]
- Use SQLAlchemy ORM (no raw SQL)
- Return None for non-existent user_id (do not raise)
- Delete is soft delete via deleted_at column
- Include transaction handling

[Done Criteria]
- [ ] All four CRUD methods implemented
- [ ] At least 2 unit tests per method
- [ ] Non-existent ID case tested
- [ ] Type hints and docstrings included
```

---

## Example 3: API Endpoint

```text
[Task]
Add POST /api/v1/users endpoint

[Files]
src/api/routes/users.py
tests/test_users_api.py

[Goal]
Implement a REST endpoint for creating a user.

[Inputs/Outputs]
input (request body):
  { "email": "string", "name": "string", "role": "user"|"admin" }
output (201):
  { "id": int, "email": str, "name": str, "role": str, "created_at": ISO8601 }
output (409): duplicate email
output (422): validation error

[Constraints]
- Return 409 on duplicate email
- Use Pydantic schema for input validation
- Modify router file only (no service layer changes)
- Do not change existing routes

[Done Criteria]
- [ ] Success case test
- [ ] Duplicate email case test
- [ ] Missing required field case test
- [ ] Response schema matches spec above
```
