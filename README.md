# <p align="center">2026年 OpenClaw 龙虾AI 一键部署教学，免费白嫖 MiniMax + Claude！</p>

<p align="center">最近更新于：2026年2月13日</p>

<!-- TODO: Hero 图片（中文文件名） -->
<!-- ![2026年OpenClaw龙虾AI一键部署教学](image/OpenClaw龙虾AI一键部署教学.png) -->

说实话，我之前一直在找好用的 AI 编程助手，后来发现了 OpenClaw（龙虾AI），直接本地部署，还能免费白嫖 MiniMax 大模型7天。配置过程也很简单，一行命令搞定，不用折腾环境。这篇教程把我踩过的坑都整理好了，照着做5分钟就能跑起来。

<blockquote>

### 🚀 一键安装 OpenClaw

* **macOS 用户**：复制粘贴一行命令，自动安装 Node.js + OpenClaw，5分钟搞定。查看：[macOS 安装](#一键安装)
* **Windows 用户**：管理员运行 PowerShell，一键安装 WSL2 + OpenClaw，重启后继续。查看：[Windows 安装](#一键安装)

### 💰 免费白嫖大模型方案

* **方法一：MiniMax 免费7天（推荐新手）**：注册即用，无需信用卡，国内直连。查看：[白嫖 MiniMax](#方法一免费白嫖-minimax7天试用)

* **方法二：AWS Bedrock $200（适合海外用户）**：新用户赠送 $200，免费用 Claude 3个月。查看：[AWS Bedrock](#方法二白嫖-aws-bedrock-claude)

* **方法三：合租拼车（长期使用）**：Claude Pro/Code 合租，14元/月起。查看：[合租拼车](#方法三通过合租拼车降低-claude-价格)

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
curl -fsSL https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/install-macos.sh | bash
```

### Windows

以**管理员身份**打开 PowerShell，运行：

```powershell
iwr -useb https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/install-windows.ps1 | iex
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

## 方法二：白嫖 AWS Bedrock Claude

AWS Bedrock 为新用户提供 **$200 免费额度**，可以免费使用 Claude Opus / Sonnet 大约 3 个月。这个方法适合**人在海外**的用户（需要海外信用卡和地址）。

### 注册 AWS Bedrock

1. 前往 [AWS 注册页面](https://aws.amazon.com/)，注册新账号
2. 绑定海外信用卡（会扣 $1 验证，之后退回）
3. 进入 [AWS Bedrock 控制台](https://console.aws.amazon.com/bedrock/)
4. 开通 Claude 模型访问权限（Model access）

### 在 OpenClaw 中配置 AWS Bedrock

配置向导中选择 **AWS Bedrock**，填入：
- AWS Access Key ID
- AWS Secret Access Key
- AWS Region（推荐 `us-east-1`）

### 免费额度说明

| 项目 | 额度 |
|------|-----|
| 新用户赠送 | $200（2个月有效）|
| Claude Opus 4.6 | 约可用 1-2 个月 |
| Claude Sonnet 4.5 | 约可用 3 个月 |

> **注意**：AWS Bedrock 需要海外信用卡和地址，国内用户可能无法注册。国内用户建议选择方法一（MiniMax）或方法三（合租）。

---

## 方法三：通过合租/拼车降低 Claude 价格

如果你需要长期使用 Claude，但觉得官方 API 太贵，可以通过第三方平台**合租 Claude Pro** 或 **Claude Code 订阅**，价格只有原价的 1/5 左右。

### 什么是 Claude 合租/拼车？

多个用户共享一个 Claude Pro 或 Claude Code 订阅账号，分摊费用。第三方平台负责管理账号和分配使用额度，每个用户都能正常使用 Claude，但价格大幅降低。

### 推荐平台

| 平台 | Claude Code 价格 | Claude Pro 价格 | 特点 |
|------|----------------|----------------|------|
| 星际放映厅 | 14元/月起 | 20元/月起 | 有备案，支持发票 |
| 其他平台 | 10-30元/月 | 15-40元/月 | 价格波动大 |

> **风险提示**：合租账号存在以下风险：
> - 可能被官方封号（虽然概率较低）
> - 平台跑路风险
> - 使用额度限制
> - 不适合企业/商业用途

### 如何在 OpenClaw 中使用合租账号？

合租平台通常提供 API Key 或 共享账号，你可以：

1. 如果提供 **API Key**：在 OpenClaw 配置向导中选择 **Anthropic**，填入平台提供的 API Key
2. 如果提供 **共享账号**：联系平台客服，询问是否支持 OpenClaw 接入

> **我的建议**：合租适合轻度使用，如果你是重度用户或企业用途，建议选择方法二（AWS Bedrock）或直接购买 Anthropic 官方 API。

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
curl -fsSL https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/uninstall-macos.sh | bash
```

### Windows（管理员 PowerShell）

```powershell
iwr -useb https://raw.githubusercontent.com/736773174/openclaw-setup-cn/main/uninstall-windows.ps1 | iex
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
