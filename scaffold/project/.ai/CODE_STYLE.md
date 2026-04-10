# CODE_STYLE.md

Load this during review sessions: `@CODE_STYLE.md`

## Core Rules
- Follow existing file style — no new style without Claude approval
- Type hints (Python) / type declarations (TypeScript) required
- Functions do one thing, ≤50 lines; nest max 3 levels
- Comments explain *why*, not *what*; no comments on self-evident code
- No `print()`/`console.log()` debug output in commits
- No unused imports, variables, or dead code

## Error Handling
- No bare `except:` or empty `catch(e) {}`
- Error messages state cause and resolution hint
- All external IO/API calls must handle failures
- Log levels: debug/info/warning/error — use correctly

## Testing
- Name: `test_[function]_[scenario]`
- One test = one scenario
- Boundary values mandatory: 0, -1, None, empty, max
- Tests must be order-independent

## Prohibited
- Hardcoded credentials, API keys, tokens anywhere in source
- `any` type abuse (TypeScript) / `Any` abuse (Python)
- PR with only `TODO` comments and no implementation
