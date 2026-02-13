# ─────────────────────────────────────────────
# OpenClaw AWS Bedrock 配置脚本 (Windows)
# ─────────────────────────────────────────────

function Write-Info($msg)    { Write-Host "[信息] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)      { Write-Host "[完成] $msg" -ForegroundColor Green }
function Write-Warn($msg)    { Write-Host "[警告] $msg" -ForegroundColor Yellow }
function Write-Err($msg)     { Write-Host "[错误] $msg" -ForegroundColor Red; throw $msg }

try {

Write-Host ""
Write-Host "========================================" -ForegroundColor White
Write-Host "  OpenClaw AWS Bedrock 配置器 (Windows)" -ForegroundColor White
Write-Host "========================================" -ForegroundColor White
Write-Host ""

# ─────────────────────────────────────────────
# 步骤 1: 检查 OpenClaw
# ─────────────────────────────────────────────
Write-Info "正在检查 OpenClaw 安装..."

try {
    $null = Get-Command openclaw -ErrorAction Stop
    Write-Ok "已找到 OpenClaw。"
} catch {
    Write-Err "未找到 OpenClaw。请先运行安装脚本：`niwr -useb https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/install-windows.ps1 | iex"
}

# ─────────────────────────────────────────────
# 步骤 2: 获取 AWS 凭证
# ─────────────────────────────────────────────
$openclawDir = Join-Path $env:USERPROFILE ".openclaw"
$envFile = Join-Path $openclawDir ".env"
$configFile = Join-Path $openclawDir "openclaw.json"

$skipInput = $false

if (Test-Path $envFile) {
    $envContent = Get-Content $envFile -Raw
    if ($envContent -match "AWS_ACCESS_KEY_ID") {
        Write-Warn "检测到已存在 AWS 凭证配置"
        $useExisting = Read-Host "是否使用现有凭证? [Y/n]"
        if ($useExisting -ne "n" -and $useExisting -ne "N") {
            $skipInput = $true
            # 加载现有凭证
            foreach ($line in (Get-Content $envFile)) {
                if ($line -match '^\s*export\s+(\w+)="?([^"]*)"?') {
                    [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2], "Process")
                }
            }
            Write-Ok "使用现有凭证"
        }
    }
}

if (-not $skipInput) {
    Write-Info "请输入你的 AWS Access Key ID："
    Write-Host "(从 IAM 控制台获取)" -ForegroundColor Yellow
    $accessKey = Read-Host

    if ([string]::IsNullOrWhiteSpace($accessKey)) {
        Write-Err "AWS Access Key ID 不能为空"
    }

    Write-Info "请输入你的 AWS Secret Access Key："
    $secretKey = Read-Host -AsSecureString
    $secretKeyPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secretKey)
    )

    if ([string]::IsNullOrWhiteSpace($secretKeyPlain)) {
        Write-Err "AWS Secret Access Key 不能为空"
    }

    Write-Info "请输入 AWS 区域 (默认: us-west-2)："
    $region = Read-Host
    if ([string]::IsNullOrWhiteSpace($region)) {
        $region = "us-west-2"
    }

    $env:AWS_ACCESS_KEY_ID = $accessKey
    $env:AWS_SECRET_ACCESS_KEY = $secretKeyPlain
    $env:AWS_REGION = $region

    Write-Ok "已获取 AWS 凭证"
}

# ─────────────────────────────────────────────
# 步骤 3: 创建环境变量文件
# ─────────────────────────────────────────────
if (-not $skipInput) {
    Write-Info "正在创建 $envFile..."

    if (-not (Test-Path $openclawDir)) {
        New-Item -ItemType Directory -Path $openclawDir -Force | Out-Null
    }

    # 备份
    if (Test-Path $envFile) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        Copy-Item $envFile "$envFile.backup.$timestamp"
        Write-Warn "已备份现有 .env 文件"
    }

    $envContent = @"
# AWS Bedrock Credentials
export AWS_ACCESS_KEY_ID="$($env:AWS_ACCESS_KEY_ID)"
export AWS_SECRET_ACCESS_KEY="$($env:AWS_SECRET_ACCESS_KEY)"
export AWS_REGION="$($env:AWS_REGION)"
"@

    Set-Content -Path $envFile -Value $envContent -Encoding UTF8
    Write-Ok "已创建环境变量文件"
}

# ─────────────────────────────────────────────
# 步骤 4: 配置 openclaw.json
# ─────────────────────────────────────────────
Write-Info "正在配置 $configFile..."

# 备份
if (Test-Path $configFile) {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    Copy-Item $configFile "$configFile.backup.$timestamp"
    Write-Warn "已备份现有 openclaw.json 文件"
}

$awsRegion = if ($env:AWS_REGION) { $env:AWS_REGION } else { "us-west-2" }

$configContent = @"
{
  "gateway": {
    "mode": "local"
  },
  "models": {
    "providers": {
      "amazon-bedrock": {
        "baseUrl": "https://bedrock-runtime.$awsRegion.amazonaws.com",
        "api": "bedrock-converse-stream",
        "auth": "aws-sdk",
        "models": [
          {
            "id": "global.anthropic.claude-opus-4-6-v1",
            "name": "Claude Opus 4.6 (Bedrock)",
            "reasoning": true,
            "input": ["text", "image"],
            "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "global.anthropic.claude-opus-4-5-20251001-v1:0",
            "name": "Claude Opus 4.5 (Bedrock)",
            "reasoning": true,
            "input": ["text", "image"],
            "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "global.anthropic.claude-sonnet-4-5-20250929-v1:0",
            "name": "Claude Sonnet 4.5 (Bedrock)",
            "reasoning": true,
            "input": ["text", "image"],
            "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "global.anthropic.claude-haiku-4-5-20251001-v1:0",
            "name": "Claude Haiku 4.5 (Bedrock)",
            "reasoning": false,
            "input": ["text", "image"],
            "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "amazon-bedrock/global.anthropic.claude-sonnet-4-5-20250929-v1:0"
      }
    }
  }
}
"@

Set-Content -Path $configFile -Value $configContent -Encoding UTF8
Write-Ok "已配置 openclaw.json"

# ─────────────────────────────────────────────
# 步骤 5: 设置环境变量到当前会话
# ─────────────────────────────────────────────
Write-Info "正在设置环境变量..."

# 设置为用户级环境变量（持久化）
[Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", $env:AWS_ACCESS_KEY_ID, "User")
[Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", $env:AWS_SECRET_ACCESS_KEY, "User")
[Environment]::SetEnvironmentVariable("AWS_REGION", $env:AWS_REGION, "User")

Write-Ok "已设置用户环境变量（新 PowerShell 窗口自动生效）"

# ─────────────────────────────────────────────
# 步骤 6: 完成
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  配置摘要：" -ForegroundColor White
Write-Host "    Provider: AWS Bedrock" -ForegroundColor Cyan
Write-Host "    Region: $awsRegion" -ForegroundColor Cyan
Write-Host "    默认模型: Claude Sonnet 4.5" -ForegroundColor Cyan
Write-Host "    已配置模型:" -ForegroundColor White
Write-Host "      * Claude Opus 4.6" -ForegroundColor Cyan
Write-Host "      * Claude Opus 4.5" -ForegroundColor Cyan
Write-Host "      * Claude Sonnet 4.5" -ForegroundColor Cyan
Write-Host "      * Claude Haiku 4.5" -ForegroundColor Cyan
Write-Host ""
Write-Host "  使用方法：" -ForegroundColor White
Write-Host "    cd 你的项目路径" -ForegroundColor Gray
Write-Host "    openclaw" -ForegroundColor Cyan
Write-Host ""
Write-Host "  测试连接：" -ForegroundColor White
Write-Host "    openclaw agent --session-id test --message `"Say OK`" --local" -ForegroundColor Cyan
Write-Host ""
Write-Host "  所需 IAM 权限：" -ForegroundColor White
Write-Host "    * bedrock:InvokeModel" -ForegroundColor Yellow
Write-Host "    * bedrock:InvokeModelWithResponseStream" -ForegroundColor Yellow
Write-Host "    或使用托管策略：AmazonBedrockFullAccess" -ForegroundColor Yellow
Write-Host ""

} catch {
    Write-Host ""
    Write-Host "[错误] 脚本执行失败: $_" -ForegroundColor Red
    Write-Host ""
} finally {
    Write-Host ""
    Read-Host "按 Enter 键关闭此窗口"
}
