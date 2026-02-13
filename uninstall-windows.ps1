# ─────────────────────────────────────────────
# OpenClaw 卸载脚本 (Windows / WSL)
# ─────────────────────────────────────────────

$ErrorActionPreference = "Stop"

function Write-Info($msg)    { Write-Host "[信息] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)      { Write-Host "[完成] $msg" -ForegroundColor Green }
function Write-Warn($msg)    { Write-Host "[警告] $msg" -ForegroundColor Yellow }

Write-Host ""
Write-Host "========================================" -ForegroundColor White
Write-Host "  OpenClaw 卸载器 (Windows)" -ForegroundColor White
Write-Host "========================================" -ForegroundColor White
Write-Host ""

$uninstallScript = @'
set -e
export PATH="$HOME/.openclaw/bin:$PATH"
if command -v openclaw &>/dev/null; then
  echo "[信息] 已找到 openclaw，正在运行卸载..."
  openclaw uninstall --all --yes --non-interactive
else
  echo "[警告] 在 PATH 中未找到 openclaw，使用 npx..."
  npx -y openclaw uninstall --all --yes --non-interactive
fi
'@

Write-Info "正在卸载 WSL 中的 OpenClaw..."
wsl -d Ubuntu-24.04 -- bash -c $uninstallScript

Write-Ok "OpenClaw 已卸载。"
Write-Host ""
