---
name: antigravity-chinese
description: >-
  Installs, updates, diagnoses, self-heals, or restores Google Antigravity Chinese localization (UI + Chinese output rules while preserving native original Thinking) on macOS and Windows. Activate this skill when the user asks to localize Antigravity into Chinese, update the Chinese patch or dictionary, check localization status, fix macOS launch crash after patching, or restore the official English client.
---

# Antigravity 全生态中文本地化技能 (Antigravity Chinese Localization Skill v4.0.0)

本技能支持在 **macOS** 与 **Windows** 双平台上对 Google Antigravity 桌面客户端、VS Code 扩展及全局智能体规则执行一键汉化、热挂载更新、状态诊断、自愈启动与无损还原。

## 核心设计原则 (v4.0.0)
1. **原版思考 + 全中文输出**：
   - 客户端 UI 层通过 `isThinkingContentBoundary` 保护思考折叠框（`[data-testid="thinking-collapsible-trigger"]` 旁的 `div[role="group"]`），仅汉化按钮标题（`思考中...` / `已思考 XX 秒`），**100% 保持内部原生思考过程（Thinking）不被词典逐词硬翻**。
   - 全局插件规则 [`plugins/chinese-toolkit/rules/AGENTS.md`](./plugins/chinese-toolkit/rules/AGENTS.md) 保持模型内部推理（`Thinking / CoT`）原生自然状态，同时锁定所有正式回复、实施计划（`Implementation Plan`）、总结报告（`Walkthrough`）及工具调用状态（`toolAction / toolSummary`）全程使用简体中文。
2. **macOS 完整性校验与防闪退自愈**：
   - 打包 `app.asar` 后自动计算 Header SHA256，使用 `/usr/libexec/PlistBuddy` 同步更新 `/Applications/Antigravity.app/Contents/Info.plist` 中的 `:ElectronAsarIntegrity:Resources/app.asar:hash`，并执行 `codesign --force --deep --preserve-metadata=entitlements --sign -` 深度重签，彻底杜绝 macOS 闪退。
3. **CDP 0.1 秒免重启实时热挂载**：
   - 自动探测本机 `DevToolsActivePort`，向正在运行的桌面版窗口实时注入中文界面，无需强行关闭当前会话。
4. **轻量防膨胀打包**：
   - 始终从官方纯净基准备份 `app.asar.bak` 解包，配合 `--unpack-dir` 与单源 `agy-i18n-bundle.js` 复用，防止多次安装导致体积膨胀。

---

## 标准操作指令 (Agent Execution Runbook)

### 1. 一键安装或更新汉化（含全局中文输出规则插件）
```bash
node cli.js install --with-plugin --no-kill
```
- **适用场景**：首次安装汉化、客户端升级后恢复汉化、更新词库或同步全局中文输出规则。
- **安全标志**：在 Antigravity 智能体会话内执行时务必附带 `--no-kill`，通过 CDP 实时热挂载生效，绝不强杀当前宿主进程。

### 2. 检查当前汉化与插件状态
```bash
node cli.js status
```
- 验证客户端 `app.asar` 补丁状态、纯净备份 `app.asar.bak` 是否存在、以及全局插件 `~/.gemini/config/plugins/chinese-toolkit` 是否就绪。

### 3. 自愈启动客户端（防官方自动更新覆盖）
```bash
node cli.js launch --no-kill
```
- 自动检测 `app.asar` 是否被官方升级覆盖，若被覆盖则静默补齐汉化与签名后再唤醒客户端。

### 4. 一键卸载并还原官方英文原版
```bash
node cli.js restore --no-kill
```
- 从 `app.asar.bak` 还原官方原生二进制包、恢复签名、移除全局中文插件，并通过 CDP 实时热还原正在运行的窗口。

---

## 双平台一键双击脚本索引

### macOS 版（双击运行）
- [`macOS/1-双击安装或更新中文汉化.command`](./macOS/1-双击安装或更新中文汉化.command)
- [`macOS/2-双击检查汉化状态.command`](./macOS/2-双击检查汉化状态.command)
- [`macOS/3-双击自愈启动Antigravity.command`](./macOS/3-双击自愈启动Antigravity.command)
- [`macOS/4-双击卸载还原官方英文.command`](./macOS/4-双击卸载还原官方英文.command)

### Windows 版（双击运行）
- [`Windows/1-双击安装或更新中文汉化.bat`](./Windows/1-双击安装或更新中文汉化.bat)
- [`Windows/2-双击检查汉化状态.bat`](./Windows/2-双击检查汉化状态.bat)
- [`Windows/3-双击自愈启动Antigravity.bat`](./Windows/3-双击自愈启动Antigravity.bat)
- [`Windows/4-双击卸载还原官方英文.bat`](./Windows/4-双击卸载还原官方英文.bat)
