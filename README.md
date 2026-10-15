# Antigravity 全生态中文本地化 Skill 与一键汉化工具 (`v4.0.0`)

<p align="left">
  <img src="https://img.shields.io/badge/Version-v4.0.0-blue?style=flat-square" alt="Version v4.0.0" />
  <img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-success?style=flat-square" alt="macOS & Windows" />
  <img src="https://img.shields.io/badge/Antigravity-2.23.x%2B%20%7C%20Skill%20%26%20Plugin-purple?style=flat-square" alt="Antigravity Skill" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License MIT" />
</p>

专为 **Google Antigravity** 桌面端、IDE 扩展及智能体打造的轻量级中文本地化套件与官方规范 **Skill（技能包）**。

---

## ✨ v4.0.0 核心特性

1. **🧠 原版思考 + 100% 中文输出（零降智架构）**
   - **UI 层思考面板保护边界 (`isThinkingContentBoundary`)**：仅汉化折叠按钮标题（`思考中...` / `已思考 XX 秒`），**100% 保护思考面板内部的模型原生思考过程（`Thinking`）不被词典逐词硬翻**。
   - **插件层单源规则 (`AGENTS.md`)**：大模型内部推理过程（`Thinking / Chain-of-Thought`）完全保持官方原版自然状态以发挥 100% 原始推理能力；同时强制锁定**正式回复正文、实施计划 (`Implementation Plan`)、总结报告 (`Walkthrough`)、提问交互及工具调用状态 (`toolAction / toolSummary`) 全程使用简体中文**。
2. **🍎 macOS 完整性校验同步与防闪退自愈**
   - 自动计算新打包 `app.asar` 的 Header SHA256，使用 `PlistBuddy` 同步更新 `/Applications/Antigravity.app/Contents/Info.plist` 中的 `ElectronAsarIntegrity` 哈希，并执行 `codesign` 深度重签名，彻底解决 macOS 修改 `app.asar` 后启动闪退的问题。
3. **⚡ CDP 0.1 秒免重启实时热挂载**
   - 自动读取本机 `DevToolsActivePort`，在不强关正在运行的 Antigravity 会话窗口的前提下，通过 Chrome DevTools Protocol 实时将中文界面热注入到所有已打开窗口。
4. **📦 极致轻量防膨胀打包（体积缩减 75%）**
   - 始终优先从官方纯净基准备份 `app.asar.bak` 解包，配合 `--unpack-dir` 与单源 `agy-i18n-bundle.js` 共享注入，杜绝多次更新导致的体积膨胀。
5. **🌐 一键云端词库增量同步**
   - 双击 1 号安装脚本时，自动从 GitHub 增量拉取合并最新中文词条，同时保护本地定制脚本与规则不被覆盖。

---

## 🚀 快速上手（macOS 版 & Windows 版按序双击）

> **前置环境**：需安装 [Node.js](https://nodejs.org/)（版本 `>= 16.0.0`）。

### 🍎 macOS 版（位于 [`macOS/`](./macOS) 目录或项目根目录）

按编号顺序直接双击运行对应的 `.command` 文件：

| 序号 | 脚本文件 | 功能说明 |
| :--- | :--- | :--- |
| **1** | [`1-双击安装或更新中文汉化.command`](./macOS/1-双击安装或更新中文汉化.command) | **【首选】** 自动同步云端最新词库 + 注入客户端中文 UI + 安装全局中文输出插件 + 自动重签防闪退 + 实时热刷新窗口 |
| **2** | [`2-双击检查汉化状态.command`](./macOS/2-双击检查汉化状态.command) | 检查当前客户端 `app.asar` 汉化状态、安全备份与全局插件状态 |
| **3** | [`3-双击自愈启动Antigravity.command`](./macOS/3-双击自愈启动Antigravity.command) | 检测官方升级是否覆盖汉化，若被覆盖则自动静默重打补丁并重签后启动客户端 |
| **4** | [`4-双击卸载还原官方英文.command`](./macOS/4-双击卸载还原官方英文.command) | 一键从 `app.asar.bak` 还原官方英文原版客户端并卸载全局中文插件 |

> 💡 **macOS 首次双击提示**：若系统提示无法打开，可在终端执行一次 `chmod +x *.command macOS/*.command`，或右键选择「打开」。

---

### 🪟 Windows 版（位于 [`Windows/`](./Windows) 目录）

进入 [`Windows/`](./Windows) 文件夹，按编号顺序双击运行对应的 `.bat` 文件：

| 序号 | 脚本文件 | 功能说明 |
| :--- | :--- | :--- |
| **1** | [`1-双击安装或更新中文汉化.bat`](./Windows/1-双击安装或更新中文汉化.bat) | **【首选】** 自动同步云端最新词库 + 一键安装客户端与 VS Code 扩展中文汉化 + 安装全局中文输出插件 |
| **2** | [`2-双击检查汉化状态.bat`](./Windows/2-双击检查汉化状态.bat) | 检查 Windows 客户端、VS Code 扩展及全局中文插件的当前状态 |
| **3** | [`3-双击自愈启动Antigravity.bat`](./Windows/3-双击自愈启动Antigravity.bat) | 自愈检测启动器（若官方自动更新覆盖了补丁，自动修复汉化并启动 `Antigravity.exe`） |
| **4** | [`4-双击卸载还原官方英文.bat`](./Windows/4-双击卸载还原官方英文.bat) | 一键还原官方英文原版客户端并清理中文插件 |

---

## 🧩 作为 Antigravity Skill（智能体技能）使用

本仓库根目录包含符合 Antigravity 官方规范的 [`SKILL.md`](./SKILL.md)，同时在 [`plugins/chinese-toolkit`](./plugins/chinese-toolkit) 内置了诊断技能与全局中文输出规则。

### 方式一：通过 1 号脚本自动安装全局插件与技能（推荐）
运行 `1-双击安装或更新中文汉化`（或执行 `node cli.js install --with-plugin --no-kill`），会自动将插件与技能安装至：
- **macOS / Linux**：`~/.gemini/config/plugins/chinese-toolkit`
- **Windows**：`%USERPROFILE%\.gemini\config\plugins\chinese-toolkit`

安装后，您可以在 Antigravity 对话框中直接用自然语言调用本技能：
- *“检查一下当前 Antigravity 汉化状态”*
- *“帮我更新一下 Antigravity 中文汉化补丁”*
- *“帮我还原 Antigravity 官方英文界面”*

### 方式二：直接克隆到全局或工作区 Skills 目录
```bash
git clone https://github.com/wansong24/antigravity-chinese-skill.git ~/.gemini/antigravity/skills/antigravity-chinese
```

---

## 💻 命令行 (CLI) 参数大全

```bash
node cli.js install --with-plugin --no-kill   # 一键安装/更新客户端汉化与全局中文插件（免重启热挂载）
node cli.js status                            # 检查当前客户端、备份与插件状态
node cli.js launch --no-kill                  # 自愈检测并启动客户端
node cli.js restore --no-kill                 # 一键卸载汉化并还原官方英文原版
node cli.js install-plugin                    # 仅安装/更新全局中文输出规则插件
node cli.js uninstall-plugin                  # 仅卸载全局中文输出规则插件
node cli.js install:vscode                    # 为 VS Code 扩展注入中文汉化
node cli.js restore:vscode                    # 还原 VS Code 扩展为英文原版
```

---

## 📂 目录结构说明

```text
antigravity-chinese-skill/
├── SKILL.md                                  # Antigravity 官方标准技能入口定义 (v4.0.0)
├── VERSION                                   # 当前版本号 (4.0.0)
├── CHANGELOG.md                              # 版本更新日志
├── README.md                                 # 双平台完整使用说明文档
├── cli.js                                    # 跨平台核心汉化与生命周期管理 CLI
├── macOS/                                    # macOS 专属按序双击脚本 (1~4.command)
├── Windows/                                  # Windows 专属按序双击脚本 (1~4.bat)
├── core/
│   ├── i18n-runtime.js                       # 前端 DOM 汉化引擎（含思考面板原版保护边界）
│   ├── cdp-client.js                         # 零依赖 WebSocket CDP 实时热注入客户端
│   └── vscode-patch.js                       # VS Code 扩展全景汉化模块
├── dict/
│   └── zh-CN.json                            # 简体中文核心翻译词库
└── plugins/
    └── chinese-toolkit/                      # 全局智能体插件包
        ├── plugin.json                       # 插件元数据清单 (v4.0.0)
        ├── rules/
        │   └── AGENTS.md                     # 唯一主规则：原版自由思考 + 100% 简体中文输出
        └── skills/
            └── i18n-diagnostics/
                └── SKILL.md                  # 内嵌本地化诊断与管理技能
```

---

## 📝 版本信息与致谢

- **当前版本**：`v4.0.0` (2026-10-15)
- **维护者**：[@wansong24](https://github.com/wansong24)
- **开源协议**：MIT License（底层词库参考并致谢开源社区 `antigravity-chinese` 项目）
