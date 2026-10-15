---
name: i18n-diagnostics
description: >-
  Installs, updates, diagnoses, self-heals, or restores Google Antigravity Chinese localization (UI + Chinese output rules while preserving native original Thinking) on macOS and Windows. Activate this skill when the user asks about Antigravity Chinese localization status, wants to install or update the Chinese patch, fix macOS launch crash after patching, or add new translation entries.
---

# Antigravity 中文本地化诊断与管理技能 (v4.0.0)

本技能用于管理 Google Antigravity 客户端（macOS & Windows）界面汉化与全局中文输出规则插件。

## 常用工作流

### 1. 检查汉化与插件状态
```bash
node cli.js status
```

### 2. 安装或更新汉化补丁（免重启热注入）
```bash
node cli.js install --with-plugin --no-kill
```

### 3. 自愈启动客户端
```bash
node cli.js launch --no-kill
```

### 4. 一键卸载还原英文原版
```bash
node cli.js restore --no-kill
```

### 5. 新增或维护翻译词库
- 编辑 `dict/zh-CN.json` 中的 `exact` 或 `patterns` 字段；
- 严禁翻译品牌词（`Google`、`Antigravity`、`Gemini`、`Claude`）与技术缩写（`API`、`CLI`、`IDE`、`MCP`、`JSON`、`DOM`）；
- 思考折叠框内部文本受 `core/i18n-runtime.js` 的 `isThinkingContentBoundary` 保护，保持模型原版思考不被静态词典替换。
