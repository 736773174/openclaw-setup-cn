# ─────────────────────────────────────────────
# OpenClaw + MiniMax 一键安装脚本 (Windows)
# 安装 WSL2 + Ubuntu，然后在 WSL 中设置 OpenClaw
# ─────────────────────────────────────────────

$ErrorActionPreference = "Stop"

function Write-Info($msg)    { Write-Host "[信息] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)      { Write-Host "[完成] $msg" -ForegroundColor Green }
function Write-Warn($msg)    { Write-Host "[警告] $msg" -ForegroundColor Yellow }
function Write-Err($msg)     { Write-Host "[错误] $msg" -ForegroundColor Red; exit 1 }

function Write-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor White
    Write-Host "  OpenClaw + MiniMax 安装器 (Windows)" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor White
    Write-Host ""
}

Write-Header

# ─────────────────────────────────────────────
# 步骤 1: 检查 / 安装 WSL2
# ─────────────────────────────────────────────
Write-Info "正在检查 WSL2 安装..."

$wslInstalled = $false
try {
    $wslOutput = wsl --status 2>&1
    if ($LASTEXITCODE -eq 0) {
        $wslInstalled = $true
    }
} catch {
    $wslInstalled = $false
}

# 检查 WSL 中是否有 Ubuntu
$ubuntuAvailable = $false
if ($wslInstalled) {
    $distros = wsl --list --quiet 2>&1
    if ($distros -match "Ubuntu") {
        $ubuntuAvailable = $true
    }
}

if (-not $wslInstalled -or -not $ubuntuAvailable) {
    Write-Info "正在安装 WSL2 和 Ubuntu 24.04..."
    Write-Warn "可能需要重启。重启后请再次运行此脚本。"

    wsl --install -d Ubuntu-24.04
    if ($LASTEXITCODE -ne 0) {
        Write-Err "WSL2 安装失败。请手动安装：wsl --install -d Ubuntu-24.04"
    }

    Write-Ok "WSL2 + Ubuntu 24.04 安装完成。"
    Write-Warn "如果提示重启，请重启计算机后再次运行此脚本。"

    # 检查是否需要重启
    $restartNeeded = $false
    try {
        wsl --status 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { $restartNeeded = $true }
    } catch {
        $restartNeeded = $true
    }

    if ($restartNeeded) {
        Write-Host ""
        Write-Warn "需要重启才能完成 WSL2 安装。"
        Write-Host "重启后，请再次运行此脚本。" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "按 Enter 键退出"
        exit 0
    }
} else {
    Write-Ok "已找到 WSL2 和 Ubuntu。"
}

# ─────────────────────────────────────────────
# 步骤 2: 在 WSL 中启用 systemd
# ─────────────────────────────────────────────
Write-Info "正在配置 WSL 中的 systemd..."

$checkSystemd = wsl -d Ubuntu-24.04 -- bash -c "cat /etc/wsl.conf 2>/dev/null || echo ''"
if ($checkSystemd -notmatch "systemd=true") {
    wsl -d Ubuntu-24.04 -- bash -c "echo '[boot]' | sudo tee /etc/wsl.conf > /dev/null && echo 'systemd=true' | sudo tee -a /etc/wsl.conf > /dev/null"
    Write-Ok "已在 /etc/wsl.conf 中启用 systemd"

    # ─────────────────────────────────────────
    # 步骤 3: 重启 WSL
    # ─────────────────────────────────────────
    Write-Info "正在重启 WSL 以应用 systemd..."
    wsl --shutdown
    Start-Sleep -Seconds 3
    Write-Ok "WSL 已重启。"
} else {
    Write-Ok "systemd 已启用。"
}

# ─────────────────────────────────────────────
# 步骤 4: 在 WSL 中安装 Node 22+
# ─────────────────────────────────────────────
Write-Info "正在检查 WSL 中的 Node.js..."

$nodeCheck = wsl -d Ubuntu-24.04 -- bash -c "command -v node && node -v || echo 'NOT_FOUND'" 2>&1
$needsNode = $true

if ($nodeCheck -notmatch "NOT_FOUND" -and $nodeCheck -match "v(\d+)") {
    $nodeVersion = [int]$Matches[1]
    if ($nodeVersion -ge 22) {
        Write-Ok "WSL 中已找到 Node.js v$nodeVersion (>= 22)。"
        $needsNode = $false
    } else {
        Write-Warn "WSL 中已找到 Node.js v$nodeVersion，但需要 >= 22。正在升级..."
    }
} else {
    Write-Warn "WSL 中未找到 Node.js。"
}

if ($needsNode) {
    Write-Info "正在通过 NodeSource 在 WSL 中安装 Node.js 22..."

    $installNodeScript = @'
set -e
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
'@

    wsl -d Ubuntu-24.04 -- bash -c $installNodeScript
    if ($LASTEXITCODE -ne 0) {
        Write-Err "WSL 中 Node.js 安装失败。"
    }
    Write-Ok "WSL 中 Node.js 22 安装完成。"
}

# ─────────────────────────────────────────────
# 步骤 5: 在 WSL 中安装 OpenClaw
# ─────────────────────────────────────────────
Write-Info "正在在 WSL 中安装 OpenClaw..."

$openclawCheck = wsl -d Ubuntu-24.04 -- bash -c "command -v openclaw || echo 'NOT_FOUND'" 2>&1

if ($openclawCheck -match "NOT_FOUND") {
    wsl -d Ubuntu-24.04 -- bash -c "curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard"
    if ($LASTEXITCODE -ne 0) {
        Write-Err "WSL 中 OpenClaw 安装失败。"
    }
    Write-Ok "WSL 中 OpenClaw 安装完成。"
} else {
    Write-Ok "WSL 中已安装 OpenClaw。"
}

# ─────────────────────────────────────────────
# 步骤 6: 安装 OpenClaw 网关守护进程
# ─────────────────────────────────────────────
Write-Info "正在安装 OpenClaw 网关守护进程..."

wsl -d Ubuntu-24.04 -- bash -c 'export PATH="$HOME/.openclaw/bin:$PATH" && openclaw gateway install'
if ($LASTEXITCODE -ne 0) {
    Write-Warn "网关守护进程安装遇到问题。您可以稍后使用以下命令安装：openclaw gateway install"
} else {
    Write-Ok "网关守护进程安装完成。"
}

# ─────────────────────────────────────────────
# 步骤 7: 启动交互式配置
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  OpenClaw 安装完成！开始配置..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  提示：当配置向导要求选择服务商时，" -ForegroundColor White
Write-Host "  选择 MiniMax 可获得 7天免费试用 - 无需信用卡。" -ForegroundColor White
Write-Host "  注册地址：https://platform.minimax.io" -ForegroundColor Cyan
Write-Host ""

wsl -d Ubuntu-24.04 -- bash -c 'export PATH="$HOME/.openclaw/bin:$PATH" && openclaw onboard --accept-risk --flow quickstart --node-manager npm --skip-skills'

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  接下来：" -ForegroundColor White
Write-Host "    1. 开始使用 OpenClaw：openclaw（在 WSL 中）" -ForegroundColor Gray
Write-Host "    2. 添加技能（可选）：openclaw configure --section skills" -ForegroundColor Gray
Write-Host "    3. 浏览可用技能：openclaw skills" -ForegroundColor Gray
Write-Host ""
