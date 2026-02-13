# ─────────────────────────────────────────────
# OpenClaw 一键部署安装脚本 (Windows)
# 安装 Node.js + OpenClaw，原生 Windows 运行
# ─────────────────────────────────────────────

function Write-Info($msg)    { Write-Host "[信息] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)      { Write-Host "[完成] $msg" -ForegroundColor Green }
function Write-Warn($msg)    { Write-Host "[警告] $msg" -ForegroundColor Yellow }
function Write-Err($msg)     { Write-Host "[错误] $msg" -ForegroundColor Red; throw $msg }

function Write-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor White
    Write-Host "  OpenClaw 一键部署安装器 (Windows)" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor White
    Write-Host ""
}

try {

Write-Header

# ─────────────────────────────────────────────
# 步骤 1: 检查 / 安装 Node.js 22+
# ─────────────────────────────────────────────
Write-Info "正在检查 Node.js..."

$needsNode = $true

try {
    $nodeVersion = (node -v 2>$null)
    if ($nodeVersion -match "v(\d+)") {
        $major = [int]$Matches[1]
        if ($major -ge 22) {
            Write-Ok "已找到 Node.js $nodeVersion"
            $needsNode = $false
        } else {
            Write-Warn "已找到 Node.js $nodeVersion，但需要 v22+，正在升级..."
        }
    }
} catch {
    Write-Warn "未找到 Node.js。"
}

if ($needsNode) {
    Write-Info "正在安装 Node.js 22..."

    $installed = $false

    # 方式 1: winget（Windows 11 / Windows 10 自带）
    if (-not $installed -and (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Info "使用 winget 安装..."
        winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0) {
            $installed = $true
            Write-Ok "Node.js 已通过 winget 安装"
        }
    }

    # 方式 2: Chocolatey
    if (-not $installed -and (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Info "使用 Chocolatey 安装..."
        choco install nodejs-lts -y 2>$null
        if ($LASTEXITCODE -eq 0) {
            $installed = $true
            Write-Ok "Node.js 已通过 Chocolatey 安装"
        }
    }

    # 方式 3: 手动下载提示
    if (-not $installed) {
        Write-Err "无法自动安装 Node.js。请手动下载安装：`n`n  下载地址：https://nodejs.cn/download/`n  或：https://nodejs.org/en/download/`n`n  安装完成后重新打开 PowerShell 运行此脚本。"
    }

    # 刷新 PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    # 验证安装
    try {
        $nodeVersion = (node -v 2>$null)
        Write-Ok "Node.js $nodeVersion 安装成功"
    } catch {
        Write-Err "Node.js 安装后验证失败。请关闭 PowerShell 重新打开后再试。"
    }
}

# ─────────────────────────────────────────────
# 步骤 2: 检查 / 安装 Git
# ─────────────────────────────────────────────
Write-Info "正在检查 Git..."

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Ok "已找到 Git。"
} else {
    Write-Info "正在安装 Git（OpenClaw 依赖需要）..."

    $gitInstalled = $false

    if (-not $gitInstalled -and (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Info "使用 winget 安装 Git..."
        winget install Git.Git --accept-package-agreements --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0) {
            $gitInstalled = $true
            Write-Ok "Git 已通过 winget 安装"
        }
    }

    if (-not $gitInstalled -and (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Info "使用 Chocolatey 安装 Git..."
        choco install git -y 2>$null
        if ($LASTEXITCODE -eq 0) {
            $gitInstalled = $true
            Write-Ok "Git 已通过 Chocolatey 安装"
        }
    }

    if (-not $gitInstalled) {
        Write-Err "无法自动安装 Git。请手动下载安装：`n`n  下载地址：https://git-scm.com/download/win`n`n  安装完成后重新打开 PowerShell 运行此脚本。"
    }

    # 刷新 PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# ─────────────────────────────────────────────
# 步骤 3: 安装 OpenClaw
# ─────────────────────────────────────────────
Write-Info "正在检查 OpenClaw..."

$needsInstall = $true

try {
    $null = Get-Command openclaw -ErrorAction Stop
    Write-Ok "已找到 OpenClaw。"
    $needsInstall = $false
} catch {
    Write-Info "正在安装 OpenClaw..."
}

if ($needsInstall) {
    npm install -g openclaw@latest 2>&1 | Write-Host
    if ($LASTEXITCODE -ne 0) {
        Write-Err "OpenClaw 安装失败。请手动运行：npm install -g openclaw@latest"
    }

    # 刷新 PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    # 把 npm global bin 加到 PATH
    try {
        $npmPrefix = (npm config get prefix 2>$null).Trim()
        if ($npmPrefix) {
            $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
            if (-not ($userPath -split ";" | Where-Object { $_ -ieq $npmPrefix })) {
                [Environment]::SetEnvironmentVariable("Path", "$userPath;$npmPrefix", "User")
                $env:Path += ";$npmPrefix"
            }
        }
    } catch {}

    Write-Ok "OpenClaw 安装完成。"
}

# ─────────────────────────────────────────────
# 步骤 3: 启动交互式配置
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

openclaw onboard --accept-risk --flow quickstart --node-manager npm --skip-skills

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  接下来：" -ForegroundColor White
Write-Host "    1. 进入项目目录：cd 你的项目路径" -ForegroundColor Gray
Write-Host "    2. 开始使用 OpenClaw：openclaw" -ForegroundColor Gray
Write-Host "    3. 添加技能（可选）：openclaw configure --section skills" -ForegroundColor Gray
Write-Host "    4. 浏览可用技能：openclaw skills" -ForegroundColor Gray
Write-Host ""

} catch {
    Write-Host ""
    Write-Host "[错误] 脚本执行失败: $_" -ForegroundColor Red
    Write-Host ""
} finally {
    Write-Host ""
    Read-Host "按 Enter 键关闭此窗口"
}
