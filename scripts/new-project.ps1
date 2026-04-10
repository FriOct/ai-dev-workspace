# new-project.ps1 — create a standalone collaboration project from scaffold

param([Parameter(Mandatory=$false, Position=0)][string]$ProjectName)

function Write-Info    { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Success { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Warn    { param($m) Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Err     { param($m) Write-Host "[ERROR] $m" -ForegroundColor Red }

if (-not $ProjectName) { Write-Err "Project name required. Usage: .\new-project.ps1 <name>"; exit 1 }
if ($ProjectName -notmatch '^[a-zA-Z0-9_-]+$') { Write-Err "Use letters, numbers, hyphens, underscores only."; exit 1 }

$TargetDir = Join-Path (Get-Location) $ProjectName
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceDir = Split-Path -Parent $ScriptDir
$ScaffoldDir = Join-Path $WorkspaceDir "scaffold\project"
$Today     = Get-Date -Format "yyyy-MM-dd"

if (Test-Path $TargetDir) { Write-Err "Already exists: $TargetDir"; exit 1 }
if (-not (Test-Path $ScaffoldDir)) { Write-Err "Missing scaffold: $ScaffoldDir"; exit 1 }

Write-Host ""; Write-Info "Create standalone project: $ProjectName -> $TargetDir"; Write-Host ""
$null = New-Item -ItemType Directory -Path $TargetDir

Copy-Item -Path (Join-Path $ScaffoldDir '*') -Destination $TargetDir -Recurse -Force
Copy-Item -Path (Join-Path $ScaffoldDir '.*') -Destination $TargetDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Success "Copied scaffold"

$ReplaceFiles = @(
  (Join-Path $TargetDir 'README.md'),
  (Join-Path $TargetDir 'PROJECT_CONTEXT.yaml')
)

foreach ($File in $ReplaceFiles) {
  (Get-Content $File -Raw).
    Replace('__PROJECT_NAME__', $ProjectName).
    Replace('__TODAY__', $Today) |
    Out-File $File -Encoding UTF8
}
Write-Success "Applied project placeholders"

if (Get-Command git -ErrorAction SilentlyContinue) {
  Push-Location $TargetDir
  git init -q; git add .; git commit -q -m "init: ${ProjectName}"
  Pop-Location
  Write-Success "Initialized git repo"
} else { Write-Warn "git not found; skipped repo init" }

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  Ready: $ProjectName"                        -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "  1. cd $ProjectName"
Write-Host "  2. Fill PROJECT_CONTEXT.yaml"
Write-Host "  3. Start Claude Code in that folder"
Write-Host ""
