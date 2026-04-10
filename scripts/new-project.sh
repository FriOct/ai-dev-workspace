#!/usr/bin/env bash
# new-project.sh — create a standalone collaboration project from scaffold

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

[ -z "$1" ] && { error "Project name required."; echo "Usage: bash new-project.sh <name>"; exit 1; }
[[ ! "$1" =~ ^[a-zA-Z0-9_-]+$ ]] && { error "Use letters, numbers, hyphens, underscores only."; exit 1; }

PROJECT_NAME="$1"
TARGET_DIR="$(pwd)/$PROJECT_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
SCAFFOLD_DIR="$WORKSPACE_DIR/scaffold/project"
TODAY=$(date +%Y-%m-%d)

[ -d "$TARGET_DIR" ] && { error "Already exists: $TARGET_DIR"; exit 1; }
[ -d "$SCAFFOLD_DIR" ] || { error "Missing scaffold: $SCAFFOLD_DIR"; exit 1; }

echo ""
info "Create standalone project: $PROJECT_NAME -> $TARGET_DIR"
echo ""

mkdir -p "$TARGET_DIR"
cp -R "$SCAFFOLD_DIR"/. "$TARGET_DIR"/
success "Copied scaffold"

find "$TARGET_DIR" -type f \
  \( -name "README.md" -o -name "PROJECT_CONTEXT.yaml" \) \
  -exec sed -i "s/__PROJECT_NAME__/${PROJECT_NAME}/g; s/__TODAY__/${TODAY}/g" {} +
success "Applied project placeholders"

if command -v git &> /dev/null; then
  (
    cd "$TARGET_DIR"
    git init -q
    git add .
    git commit -q -m "init: ${PROJECT_NAME}"
  )
  success "Initialized git repo"
else
  warn "git not found; skipped repo init"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Ready: ${PROJECT_NAME}${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Location: $TARGET_DIR"
echo ""
echo "  Next:"
echo "  1. cd ${PROJECT_NAME}"
echo "  2. Fill PROJECT_CONTEXT.yaml"
echo "  3. Start Claude Code in that folder"
echo ""
