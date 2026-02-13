# ─────────────────────────────────────────────
# OpenClaw AWS Bedrock 配置脚本 (Windows)
# 在 WSL 中运行 bash 配置脚本
# ─────────────────────────────────────────────

$ErrorActionPreference = "Stop"

function Write-Info($msg)    { Write-Host "[信息] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)      { Write-Host "[完成] $msg" -ForegroundColor Green }
function Write-Warn($msg)    { Write-Host "[警告] $msg" -ForegroundColor Yellow }
function Write-Err($msg)     { Write-Host "[错误] $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "========================================" -ForegroundColor White
Write-Host "  OpenClaw AWS Bedrock 配置器 (Windows)" -ForegroundColor White
Write-Host "========================================" -ForegroundColor White
Write-Host ""

# ─────────────────────────────────────────────
# 步骤 1: 检查 WSL
# ─────────────────────────────────────────────
Write-Info "正在检查 WSL 环境..."

$wslOk = $false
try {
    $distros = wsl --list --quiet 2>&1
    if ($LASTEXITCODE -eq 0 -and $distros -match "Ubuntu") {
        $wslOk = $true
    }
} catch {}

if (-not $wslOk) {
    Write-Err "未找到 WSL2 + Ubuntu。请先运行安装脚本：`niwr -useb https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/install-windows.ps1 | iex"
}

Write-Ok "已找到 WSL2 + Ubuntu。"

# ─────────────────────────────────────────────
# 步骤 2: 检查 OpenClaw
# ─────────────────────────────────────────────
Write-Info "正在检查 OpenClaw 安装..."

$openclawCheck = wsl -d Ubuntu-24.04 -- bash -c 'export PATH="$HOME/.openclaw/bin:$PATH" && command -v openclaw || echo NOT_FOUND' 2>&1

if ($openclawCheck -match "NOT_FOUND") {
    Write-Err "未找到 OpenClaw。请先运行安装脚本：`niwr -useb https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/install-windows.ps1 | iex"
}

Write-Ok "已找到 OpenClaw。"

# ─────────────────────────────────────────────
# 步骤 3: 在 WSL 中运行配置脚本
# ─────────────────────────────────────────────
Write-Info "正在 WSL 中启动 AWS Bedrock 配置..."
Write-Host ""

wsl -d Ubuntu-24.04 -- bash -c 'export PATH="$HOME/.openclaw/bin:$PATH" && curl -fsSL https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/configure-aws-bedrock.sh | bash -s < /dev/tty'

if ($LASTEXITCODE -ne 0) {
    Write-Warn "配置脚本执行过程中遇到问题。"
    Write-Host "  你可以手动在 WSL 中运行：" -ForegroundColor Gray
    Write-Host "    wsl" -ForegroundColor Cyan
    Write-Host "    curl -fsSL https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/configure-aws-bedrock.sh | bash" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  AWS Bedrock 配置完成！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  使用方法（在 WSL 中）：" -ForegroundColor White
    Write-Host "    wsl" -ForegroundColor Cyan
    Write-Host "    source ~/.openclaw/.env" -ForegroundColor Cyan
    Write-Host "    openclaw tui" -ForegroundColor Cyan
    Write-Host ""
}
