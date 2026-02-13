#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# OpenClaw 一键部署安装脚本 (macOS)
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
  echo -e "${BOLD}  OpenClaw 一键部署安装器 (macOS)${NC}"
  echo -e "${BOLD}========================================${NC}"
  echo ""
}

header

# ─────────────────────────────────────────────
# 步骤 1: 检查 / 安装 Node 22+
# ─────────────────────────────────────────────
info "正在检查 Node.js 版本..."

install_node() {
  # 检查是否安装了 Homebrew
  if ! command -v brew &>/dev/null; then
    info "未找到 Homebrew，正在安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 为 Apple Silicon 添加 Homebrew 到 PATH
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    success "Homebrew 安装完成。"
  else
    success "已找到 Homebrew。"
  fi

  info "正在通过 Homebrew 安装 Node.js 22..."
  brew install node@22
  brew link --overwrite node@22 2>/dev/null || true
  success "Node.js 22 安装完成。"
}

if command -v node &>/dev/null; then
  NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
  if [[ "$NODE_VERSION" -ge 22 ]]; then
    success "已找到 Node.js v$(node -v | sed 's/v//') (>= 22)。"
  else
    warn "已找到 Node.js v$(node -v | sed 's/v//')，但需要 >= 22。"
    install_node
  fi
else
  warn "未找到 Node.js。"
  install_node
fi

# ─────────────────────────────────────────────
# 步骤 2: 安装 OpenClaw
# ─────────────────────────────────────────────
info "正在安装 OpenClaw..."

if command -v openclaw &>/dev/null; then
  success "OpenClaw 已安装。"
else
  curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard
  success "OpenClaw 安装完成。"
fi

# 确保 openclaw 在 PATH 中
export PATH="$HOME/.openclaw/bin:$PATH"

if ! command -v openclaw &>/dev/null; then
  error "OpenClaw 安装失败 — 在 PATH 中找不到 'openclaw'。请尝试重启终端后再次运行此脚本。"
fi

# ─────────────────────────────────────────────
# 步骤 3: 启动交互式配置
# ─────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}  OpenClaw 安装完成！开始配置...${NC}"
echo -e "${GREEN}${BOLD}========================================${NC}"
echo ""
echo -e "  ${BOLD}提示：${NC}当配置向导要求选择服务商时，"
echo -e "  选择 ${BOLD}MiniMax${NC} 可获得 ${BOLD}7天免费试用${NC} — 无需信用卡。"
echo -e "  注册地址：${BLUE}https://platform.minimax.io${NC}"
echo ""

openclaw onboard --accept-risk --flow quickstart --node-manager npm --skip-skills < /dev/tty

echo ""
echo -e "${GREEN}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}  配置完成！${NC}"
echo -e "${GREEN}${BOLD}========================================${NC}"
echo ""
echo -e "  ${BOLD}接下来：${NC}"
echo -e "    1. 开始使用 OpenClaw：${BLUE}openclaw${NC}"
echo -e "    2. 添加技能（可选）：${BLUE}openclaw configure --section skills${NC}"
echo -e "    3. 浏览可用技能：${BLUE}openclaw skills${NC}"
echo ""
