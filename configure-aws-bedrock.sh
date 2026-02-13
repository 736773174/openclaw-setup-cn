#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# OpenClaw AWS Bedrock 配置脚本
# ─────────────────────────────────────────────

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # 无颜色

info()    { echo -e "${BLUE}[信息]${NC} $*"; }
success() { echo -e "${GREEN}[完成]${NC} $*"; }
warn()    { echo -e "${YELLOW}[警告]${NC} $*"; }
error()   { echo -e "${RED}[错误]${NC} $*"; exit 1; }

header() {
  echo ""
  echo -e "${BOLD}========================================${NC}"
  echo -e "${BOLD}  OpenClaw AWS Bedrock 配置器${NC}"
  echo -e "${BOLD}========================================${NC}"
  echo ""
}

header

# ─────────────────────────────────────────────
# 检查是否已配置
# ─────────────────────────────────────────────
SKIP_INPUT=false

if [[ -f ~/.openclaw/.env ]] && grep -q "AWS_ACCESS_KEY_ID" ~/.openclaw/.env 2>/dev/null; then
  warn "检测到已存在 AWS 凭证配置"
  echo -e "${YELLOW}是否使用现有凭证? [Y/n]${NC}"
  read -r USE_EXISTING

  if [[ "$USE_EXISTING" != "n" && "$USE_EXISTING" != "N" ]]; then
    SKIP_INPUT=true
    # 加载现有凭证
    source ~/.openclaw/.env
    success "使用现有凭证 (Access Key: ${AWS_ACCESS_KEY_ID:0:20}...)"
  fi
fi

# ─────────────────────────────────────────────
# 步骤 1: 获取 AWS 访问密钥
# ─────────────────────────────────────────────
if [[ "$SKIP_INPUT" == false ]]; then
  info "请输入你的 AWS Access Key ID："
  echo -e "${YELLOW}(从 https://console.aws.amazon.com/bedrock/home#/api-keys 获取)${NC}"
  read -r AWS_ACCESS_KEY_ID

  if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    error "AWS Access Key ID 不能为空"
  fi

  info "请输入你的 AWS Secret Access Key："
  read -sr AWS_SECRET_ACCESS_KEY
  echo ""

  if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    error "AWS Secret Access Key 不能为空"
  fi

  info "请输入 AWS 区域 (默认: us-west-2)："
  read -r AWS_REGION
  AWS_REGION=${AWS_REGION:-us-west-2}

  success "已获取 AWS 凭证"
fi

# ─────────────────────────────────────────────
# 步骤 1.5: 创建环境变量文件
# ─────────────────────────────────────────────
if [[ "$SKIP_INPUT" == false ]]; then
  info "正在创建 ~/.openclaw/.env 文件..."

  mkdir -p ~/.openclaw

  # 备份现有的 .env 文件
  if [[ -f ~/.openclaw/.env ]]; then
    cp ~/.openclaw/.env ~/.openclaw/.env.backup.$(date +%s)
    warn "已备份现有 .env 文件"
  fi

  cat > ~/.openclaw/.env <<EOF
# AWS Bedrock Credentials
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_REGION="${AWS_REGION}"
EOF

  success "已创建环境变量文件"
else
  info "跳过环境变量文件创建（使用现有配置）"
fi

# ─────────────────────────────────────────────
# 步骤 2: 配置 openclaw.json
# ─────────────────────────────────────────────
info "正在配置 ~/.openclaw/openclaw.json..."

mkdir -p ~/.openclaw

# 备份现有配置
if [[ -f ~/.openclaw/openclaw.json ]]; then
  cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%s)
  warn "已备份现有 openclaw.json 文件"
fi

# 写入配置 (手动配置)
cat > ~/.openclaw/openclaw.json <<EOF
{
  "gateway": {
    "mode": "local"
  },
  "models": {
    "providers": {
      "amazon-bedrock": {
        "baseUrl": "https://bedrock-runtime.${AWS_REGION}.amazonaws.com",
        "api": "bedrock-converse-stream",
        "auth": "aws-sdk",
        "models": [
          {
            "id": "global.anthropic.claude-opus-4-6-v1",
            "name": "Claude Opus 4.6 (Bedrock)",
            "reasoning": true,
            "input": ["text", "image"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "global.anthropic.claude-opus-4-5-20251001-v1:0",
            "name": "Claude Opus 4.5 (Bedrock)",
            "reasoning": true,
            "input": ["text", "image"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "global.anthropic.claude-sonnet-4-5-20250929-v1:0",
            "name": "Claude Sonnet 4.5 (Bedrock)",
            "reasoning": true,
            "input": ["text", "image"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "global.anthropic.claude-haiku-4-5-20251001-v1:0",
            "name": "Claude Haiku 4.5 (Bedrock)",
            "reasoning": false,
            "input": ["text", "image"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
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
EOF

success "已配置 openclaw.json"

# ─────────────────────────────────────────────
# 步骤 3: 完成
# ─────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}  配置完成！${NC}"
echo -e "${GREEN}${BOLD}========================================${NC}"
echo ""
echo -e "  ${BOLD}配置摘要：${NC}"
echo -e "    Provider: ${BLUE}AWS Bedrock (手动配置)${NC}"
echo -e "    Region: ${BLUE}${AWS_REGION}${NC}"
echo -e "    默认模型: ${BLUE}Claude Sonnet 4.5${NC}"
echo -e "    已配置模型:"
echo -e "      • ${BLUE}Claude Opus 4.6 (amazon-bedrock/global.anthropic.claude-opus-4-6-v1)${NC}"
echo -e "      • ${BLUE}Claude Opus 4.5 (amazon-bedrock/global.anthropic.claude-opus-4-5-20251001-v1:0)${NC}"
echo -e "      • ${BLUE}Claude Sonnet 4.5 (amazon-bedrock/global.anthropic.claude-sonnet-4-5-20250929-v1:0)${NC}"
echo -e "      • ${BLUE}Claude Haiku 4.5 (amazon-bedrock/global.anthropic.claude-haiku-4-5-20251001-v1:0)${NC}"
echo ""
echo -e "  ${BOLD}所需 IAM 权限：${NC}"
echo -e "    ${YELLOW}确保你的 AWS 凭证具有以下权限：${NC}"
echo -e "      • ${BLUE}bedrock:InvokeModel${NC}"
echo -e "      • ${BLUE}bedrock:InvokeModelWithResponseStream${NC}"
echo -e "    ${YELLOW}或使用托管策略：${BLUE}AmazonBedrockFullAccess${NC}"
echo ""
echo -e "  ${BOLD}使用方法：${NC}"
echo ""
echo -e "    ${BLUE}# 加载 AWS 凭证到环境变量${NC}"
echo -e "    ${BLUE}source ~/.openclaw/.env${NC}"
echo ""
echo -e "    ${BLUE}# 启动 OpenClaw TUI${NC}"
echo -e "    ${BLUE}openclaw tui${NC}"
echo ""
echo -e "  ${BOLD}测试命令：${NC}"
echo ""
echo -e "    ${BLUE}# 检查 Gateway 健康状态${NC}"
echo -e "    ${BLUE}openclaw gateway health${NC}"
echo ""
echo -e "    ${BLUE}# 列出 AWS Bedrock 模型${NC}"
echo -e "    ${BLUE}openclaw models list --provider amazon-bedrock${NC}"
echo ""
echo -e "    ${BLUE}# 测试发送消息${NC}"
echo -e "    ${BLUE}openclaw agent --local --message \"Hello, test connection\"${NC}"
echo ""
echo -e "  ${BOLD}注意：${NC}"
echo -e "    - 使用前必须先运行 ${BLUE}source ~/.openclaw/.env${NC}"
echo -e "    - 建议将 ${BLUE}source ~/.openclaw/.env${NC} 添加到 ~/.bashrc 或 ~/.zshrc"
echo -e "    - 确保在 AWS Bedrock 控制台启用了这些模型的访问权限"
echo -e "    - 如需添加更多模型，编辑 ${BLUE}~/.openclaw/openclaw.json${NC}"
echo ""

# ─────────────────────────────────────────────
# 步骤 4: 重启 Gateway
# ─────────────────────────────────────────────
info "正在重启 OpenClaw Gateway 以应用新配置..."

# 先加载环境变量
source ~/.openclaw/.env

# 重启 gateway
if openclaw gateway restart 2>/dev/null; then
  success "Gateway 已重启"
else
  warn "Gateway 重启失败，请手动运行: ${BLUE}openclaw gateway restart${NC}"
fi

echo ""

# ─────────────────────────────────────────────
# 步骤 5: 测试连接
# ─────────────────────────────────────────────
info "正在测试 AWS Bedrock 连接..."

# 等待 gateway 完全启动
sleep 2

# 检查 gateway 健康状态
if openclaw gateway health --timeout 5000 >/dev/null 2>&1; then
  success "Gateway 运行正常"
else
  warn "Gateway 健康检查失败"
fi

# 列出配置的模型
info "检查已配置的 AWS Bedrock 模型..."
echo ""
openclaw models list --provider amazon-bedrock 2>/dev/null || warn "无法列出模型，请检查配置"

echo ""

# 测试实际连接
info "测试实际连接到 AWS Bedrock..."
echo ""
if openclaw agent --session-id test --message "Say OK" --local 2>/dev/null; then
  echo ""
  success "AWS Bedrock 连接测试成功！"
else
  warn "AWS Bedrock 连接测试失败，请检查："
  echo -e "    • AWS 凭证是否正确"
  echo -e "    • AWS Bedrock 模型访问是否已启用"
  echo -e "    • IAM 权限是否配置正确"
fi

echo ""
echo -e "${GREEN}${BOLD}✓ 测试完成${NC}"
echo ""
