# AI Dev Workspace

독립형 Claude Code + Codex 프로젝트를 만들기 위한 소스 워크스페이스다.

이 저장소는 실제로 오래 작업하는 프로젝트 폴더가 아니라, 새 프로젝트를 생성하는 생성기 역할을 한다.
실제 개발은 여기서 만든 프로젝트 폴더 안에서 진행하면 된다.

설계 목표는 아래와 같다.

- 생성된 프로젝트가 독립적으로 동작할 것
- 루트에 보이는 파일 수를 최소화할 것
- 항상 로드되는 컨텍스트를 작게 유지할 것
- Claude / Codex 역할 분리를 명확히 할 것
- 지원 문서는 `.ai/` 아래 숨길 것

프로젝트 템플릿 파일은 `scaffold/project/` 아래에 있다.

## 용도

이 워크스페이스는 아래 3단계 협업 루프를 위한 것이다.

1. Claude에서 분석 / 설계
2. Codex에서 구현
3. Claude에서 검증 / 최종 리뷰

중앙 워크스페이스를 계속 들고 가는 대신, `new-project`는 필요한 문서와 규칙을 포함한 독립형 프로젝트를 생성한다.

## 빠른 시작

Linux / macOS:

```bash
bash scripts/new-project.sh my-project
cd my-project
```

Windows:

```powershell
.\scripts\new-project.ps1 my-project
cd .\my-project
```

그다음 순서:

1. `PROJECT_CONTEXT.yaml` 작성
2. 생성된 프로젝트 폴더에서 Claude Code 실행
3. Claude에게 분석 또는 설계 요청
4. `TASK.template.md`를 복사해 채운 뒤 Codex에 전달
5. 결과를 다시 Claude에게 가져와 리뷰

## 생성되는 파일

생성된 프로젝트의 루트에는 아래 파일만 보인다.

- `README.md`
- `CLAUDE.md`
- `AGENTS.md`
- `PROJECT_CONTEXT.yaml`
- `TASK.template.md`

숨김 지원 파일:

- `.ai/CODE_STYLE.md`
- `.ai/CAVEMAN.md`
- `.ai/docs/TASK_GUIDE.md`
- `.ai/docs/WORKFLOW_GUIDE.md`

이 구조의 장점:

- 루트가 깔끔함
- `ai-dev-workspace/` 없이도 프로젝트를 계속 사용할 수 있음
- 필요할 때 참고 문서도 그대로 남아 있음

## 생성된 프로젝트가 동작하는 방식

### `CLAUDE.md`

Claude Code의 자동 로드 진입점이다.
아래 파일들을 불러온다.

- `AGENTS.md`
- `PROJECT_CONTEXT.yaml`
- `.ai/CAVEMAN.md`

### `AGENTS.md`

Claude와 Codex가 함께 따르는 작업 규칙이다.
아래 내용을 담는다.

- 역할 분리
- 작업 범위 규칙
- 보안 규칙
- 태스크 형식
- 리뷰 순서
- caveman 지원

### `PROJECT_CONTEXT.yaml`

구조화된 프로젝트 메모다.
아래 정보를 기록한다.

- 목적
- 스택
- 구조
- 공개 인터페이스
- 제약사항
- 모듈
- 상태
- 우선순위
- 설계 결정

### `TASK.template.md`

Codex에 전달할 최소 태스크 형식이다.
복사해서 채운 뒤 구현 작업용으로 Codex에 붙여넣으면 된다.

### `.ai/`

숨김 지원 문서 폴더다.
아래 용도로 사용한다.

- 스타일 리뷰
- caveman 모드
- 워크플로 참고
- 태스크 예시

## 권장 작업 흐름

### 1. Claude에서 설계

생성된 프로젝트 폴더에서 Claude Code를 실행한다.
`CLAUDE.md`가 핵심 컨텍스트를 자동 로드한다.

Claude에게 요청할 것:

- 요구사항 명확화
- 아키텍처 방향
- 인터페이스 결정
- 태스크 분해

중요한 결정이 확정되면 `PROJECT_CONTEXT.yaml`을 업데이트한다.

### 2. Codex에서 구현

`TASK.template.md`를 실제 태스크로 채운 뒤 Codex에 전달한다.

좋은 태스크는 아래를 포함해야 한다.

- 정확한 파일 경로
- 구체적인 목표
- 명시적인 입력 / 출력
- 제약사항 안의 명시적 금지 조건
- 독립적으로 검증 가능한 완료 기준

예시는 `.ai/docs/TASK_GUIDE.md` 참고.

### 3. Claude에서 검증

원래 태스크와 변경된 파일을 다시 Claude에게 가져온다.
아래 문서를 기준으로 리뷰한다.

- `AGENTS.md` — 리뷰 순서
- `.ai/CODE_STYLE.md` — 스타일 민감한 리뷰

Claude는 아래를 검증해야 한다.

- 정확성
- 범위 준수
- 품질
- 테스트
- 보안

## Caveman 모드

생성되는 모든 프로젝트에는 `.ai/CAVEMAN.md`가 포함된다.

Claude:
- `CLAUDE.md`를 통해 자동 로드

Codex:
- `AGENTS.md`를 통해 지원

주요 트리거 예시:

- `caveman`
- `caveman mode`
- `talk like caveman`
- `be brief`
- `/caveman`

## 워크스페이스 구조

이 저장소 자체는 작게 유지한다.

- `scripts/` — 프로젝트 생성기
- `scaffold/project/` — 독립형 프로젝트에 복사되는 파일
- `docs/notes/` — 내부 참고 메모와 brief

## 참고

- 생성된 프로젝트는 독립적으로 동작하도록 설계되었다
- 숨김 `.ai/` 문서는 의도적으로 함께 복사된다
- scaffold 파일을 바꿔도 이미 생성된 프로젝트에는 자동 반영되지 않고, 새 프로젝트부터 반영된다
