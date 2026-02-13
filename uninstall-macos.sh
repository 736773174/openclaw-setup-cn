#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# OpenClaw 卸载脚本 (macOS)
# ─────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[信息]${NC} $*"; }
success() { echo -e "${GREEN}[完成]${NC} $*"; }
warn()    { echo -e "${YELLOW}[警告]${NC} $*"; }

echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}  OpenClaw 卸载器 (macOS)${NC}"
echo -e "${BOLD}========================================${NC}"
echo ""

if command -v openclaw &>/dev/null; then
  info "已找到 openclaw，正在运行卸载..."
  openclaw uninstall --all --yes --non-interactive
else
  warn "在 PATH 中未找到 openclaw，使用 npx..."
  npx -y openclaw uninstall --all --yes --non-interactive
fi

success "OpenClaw 已卸载。"
echo ""
