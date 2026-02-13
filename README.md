# <p align="center">2026年 OpenClaw 龙虾AI 一键部署教学，免费白嫖 MiniMax + Claude！</p>

<p align="center">最近更新于：2026年2月13日</p>

<!-- TODO: Hero 图片（中文文件名） -->
<!-- ![2026年OpenClaw龙虾AI一键部署教学](image/OpenClaw龙虾AI一键部署教学.png) -->

说实话，我之前用 Claude Code 每个月烧几百块，后来发现了 OpenClaw（龙虾AI），直接本地部署，还能免费白嫖 MiniMax 大模型7天。配置过程也很简单，一行命令搞定，不用折腾环境。这篇教程把我踩过的坑都整理好了，照着做5分钟就能跑起来。

<blockquote>

* **方法一：免费白嫖 MiniMax 7天（适合想先体验的用户）**：MiniMax 提供7天免费试用，注册即可使用，无需信用卡。20万 token 上下文窗口，编程能力很强。查看更多：[免费白嫖 MiniMax](#方法一免费白嫖-minimax7天试用)

* **方法二：接入 Claude（适合已有 API Key 的用户）**：如果你已经有 Anthropic API Key，可以直接在 OpenClaw 中使用 Claude Opus / Sonnet，体验和 Claude Code 一样。查看更多：[接入 Claude](#方法二接入-claude)

* **方法三：其他免费/低价模型（适合长期免费用户）**：通过 OpenRouter 等平台接入免费模型，或者使用其他低价大模型。查看更多：[其他模型](#方法三其他免费低价模型)

</blockquote>

---

## OpenClaw 龙虾AI 是什么？

[OpenClaw（龙虾AI / ClawsBot）](https://openclaw.ai)是一款**开源**的 AI 编程助手，直接在你的终端里运行，所有数据都在本地，不会上传到任何第三方服务器。

你可以把它理解为一个**免费的、开源的 Claude Code 替代品**，而且支持接入多种大模型（MiniMax、Claude、GPT、Gemini 等）。

### OpenClaw vs Claude Code vs Cursor 对比

| 特性 | OpenClaw 龙虾AI | Claude Code | Cursor |
|------|----------------|-------------|--------|
| 价格 | **免费开源** | $20/月（Pro）| $20/月（Pro）|
| 运行方式 | 本地终端 | 本地终端 | IDE |
| 模型选择 | 多模型自由切换 | 仅 Claude | 多模型 |
| 数据隐私 | 数据不出本机 | 云端处理 | 云端处理 |
| 国内可用 | **支持国内模型** | 需要翻墙 | 需要翻墙 |
| 开源 | **完全开源** | 否 | 否 |

<!-- TODO: 添加 OpenClaw 使用截图 -->

---

## 一键安装

### macOS

打开终端，粘贴以下命令：

```bash
curl -fsSL https://raw.githubusercontent.com/anthropics/openclaw-minimax-setup/main/install-macos.sh | bash
```

### Windows

以**管理员身份**打开 PowerShell，运行：

```powershell
iwr -useb https://raw.githubusercontent.com/anthropics/openclaw-minimax-setup/main/install-windows.ps1 | iex
```

> **Windows 说明：** 脚本会自动安装 WSL2（Windows 子系统 Linux）。可能需要重启，重启后再次运行脚本即可。

### 脚本做了什么？

完全透明 — 以下是脚本的具体操作：

| 步骤 | macOS | Windows |
|------|-------|---------|
| 1 | 检查/安装 Node.js 22+（通过 Homebrew） | 检查/安装 WSL2 + Ubuntu 24.04 |
| 2 | 安装 OpenClaw（静默安装） | 启用 systemd + 安装 Node.js 22+ |
| 3 | 启动配置向导 | 安装 OpenClaw + 网关守护进程 |
| 4 | — | 启动配置向导 |

脚本不会在 Homebrew (macOS) 或 WSL (Windows) 之外安装任何东西。

---

## 方法一：免费白嫖 MiniMax（7天试用）

MiniMax 是国内领先的 AI 大模型公司，他们的 MiniMax-M2.1 模型提供**7天免费试用**，无需信用卡，注册即可使用。

### 注册步骤

1. 前往 [platform.minimax.io](https://platform.minimax.io) 注册账号
2. 在控制台找到 **API Keys**
3. 点击 **创建新密钥**，复制保存

<!-- TODO: 添加 MiniMax 注册截图 -->

### 在配置向导中选择 MiniMax

安装脚本运行后会自动进入配置向导，选择服务商时：

- 选择 **MiniMax**（国际版）或 **MiniMax CN**（国内版，国内访问更快）
- 粘贴你的 API Key

<!-- TODO: 添加配置向导截图 -->

### MiniMax vs Claude 编程能力对比

| 指标 | MiniMax-M2.1 | Claude Sonnet 4.5 |
|------|-------------|-------------------|
| 上下文窗口 | 20万 tokens | 20万 tokens |
| 最大输出 | 8,192 tokens | 8,192 tokens |
| 编程能力 | 强 | 非常强 |
| 价格 | **7天免费** | 按量付费 |
| 国内访问 | **直连，无需翻墙** | 需要翻墙 |

> **我的体验**：MiniMax-M2.1 的编程能力已经很不错了，日常写代码、debug、重构都没问题。如果你是第一次用 AI 编程助手，先白嫖7天体验一下，不满意再换。

<p align="center"><a href="https://platform.minimax.io">立即注册 MiniMax 免费账号</a></p>

---

## 方法二：接入 Claude

如果你已经有 Anthropic API Key，可以在 OpenClaw 配置向导中选择 **Anthropic**，直接使用 Claude Opus 4.6 / Sonnet 4.5 等模型。

### 获取 Claude API Key

1. 前往 [console.anthropic.com](https://console.anthropic.com)
2. 注册账号并添加付款方式
3. 在 **API Keys** 中创建新密钥

### 价格参考

| 模型 | 输入价格 | 输出价格 |
|------|---------|---------|
| Claude Opus 4.6 | $15 / 百万 tokens | $75 / 百万 tokens |
| Claude Sonnet 4.5 | $3 / 百万 tokens | $15 / 百万 tokens |
| Claude Haiku 4.5 | $0.80 / 百万 tokens | $4 / 百万 tokens |

> **提示**：日常编程用 Sonnet 4.5 性价比最高，遇到复杂架构问题再切换到 Opus。

---

## 方法三：其他免费/低价模型

OpenClaw 支持接入多种模型，配置向导中可以选择：

| 服务商 | 免费额度 | 适合场景 |
|--------|---------|---------|
| OpenRouter | 部分模型免费 | 想要多模型切换 |
| Google Gemini | 免费额度 | 日常使用 |
| xAI (Grok) | 免费额度 | 尝鲜 |
| Moonshot (Kimi) | 免费额度 | 国内直连 |

---

## 安装完成后怎么用？

### macOS

```bash
cd 你的项目目录
openclaw
```

### Windows

```powershell
wsl
cd /mnt/c/Users/你的用户名/项目目录
openclaw
```

### 添加技能（可选）

安装脚本跳过了技能配置，让你更快上手。后续添加技能：

```bash
openclaw configure --section skills
```

浏览可用技能：

```bash
openclaw skills
```

---

## 卸载 OpenClaw

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/anthropics/openclaw-minimax-setup/main/uninstall-macos.sh | bash
```

### Windows（管理员 PowerShell）

```powershell
iwr -useb https://raw.githubusercontent.com/anthropics/openclaw-minimax-setup/main/uninstall-windows.ps1 | iex
```

---

## 常见问题

### OpenClaw 龙虾AI 是什么？和 Claude Code 有什么区别？

OpenClaw 是一款开源的 AI 编程助手，功能类似 Claude Code，但完全免费、开源，而且支持接入多种大模型（不限于 Claude）。数据全部在本地处理，隐私性更好。

### 国内能用吗？需要翻墙吗？

**选 MiniMax 或 MiniMax CN 就不需要翻墙**。如果选择 Claude 或 OpenAI 等国外模型，则需要科学上网。

### MiniMax 免费试用到期后怎么办？

到期后可以：
1. 继续付费使用 MiniMax
2. 切换到其他模型（在配置中修改）：`openclaw onboard`
3. 使用 OpenRouter 等平台的免费额度

### "openclaw: command not found" 怎么解决？

Shell 可能没有加载新的 PATH：

```bash
# macOS
source ~/.zshrc
# 或者
export PATH="$HOME/.openclaw/bin:$PATH"

# Windows（在 WSL 中）
source ~/.bashrc
```

### Node.js 版本太旧怎么办？

```bash
# macOS
brew install node@22 && brew link --overwrite node@22

# Windows（在 WSL 中）
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### WSL2 安装失败怎么办？（Windows）

1. 确保以**管理员身份**运行 PowerShell
2. 在 BIOS 中检查虚拟化是否已启用
3. 运行 `wsl --update` 更新到最新版本
4. 手动安装：`wsl --install -d Ubuntu-24.04`

### 怎么重新选择模型/服务商？

```bash
openclaw onboard
```

### "openclaw doctor" 报错怎么办？

运行 `openclaw doctor` 查看具体哪项检查失败：
- **Node 版本**：升级到 Node 22+
- **API 连接**：检查网络连接和 API Key
- **网关**（Windows）：在 WSL 中运行 `openclaw gateway install`

---

## 相关链接

- [OpenClaw 龙虾AI 官方文档](https://openclaw.ai/docs)
- [OpenClaw GitHub](https://github.com/anthropics/openclaw)
- [MiniMax 平台](https://platform.minimax.io)
- [MiniMax API 文档](https://platform.minimax.io/docs)
- [Anthropic Console](https://console.anthropic.com)

---

## 关键词

OpenClaw, 龙虾AI, ClawsBot, MiniMax, Claude, AI编程助手, 一键部署, 免费白嫖, 本地AI, 终端AI助手, MiniMax-M2.1, 开源编程助手, Claude Code 替代品, AI coding assistant, 大模型编程, 国内AI编程, 免费AI编码工具

---

## 免责声明

本教程仅供学习和参考使用。MiniMax 免费试用政策以官方为准，如有变动请以 [platform.minimax.io](https://platform.minimax.io) 最新信息为准。Claude API 按量计费，请注意控制用量。

## 许可证

MIT
