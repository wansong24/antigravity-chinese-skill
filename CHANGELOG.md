# 版本更新日志 (Changelog)

## v4.0.0 (2026-10-15)

### ✨ 新增功能 (Features)
- **标准 Antigravity Skill 封装**：新增根目录 [`SKILL.md`](./SKILL.md) 及插件内嵌技能定义，支持智能体自动识别并执行安装、更新、诊断、自愈启动与还原工作流。
- **macOS & Windows 双平台编号一键脚本**：
  - 新增 [`macOS/`](./macOS) 与 [`Windows/`](./Windows) 专属目录，按 `1-安装更新`、`2-检查状态`、`3-自愈启动`、`4-卸载还原` 编号排序，开箱即用。
  - 1 号脚本内置 GitHub 云端词库增量同步引擎，自动拉取新增词条并保护本地定制逻辑。
- **macOS `ElectronAsarIntegrity` 签名自愈引擎**：打包 `app.asar` 后自动计算 Header SHA256 并写入 `Info.plist`，配合 `codesign --force --deep --preserve-metadata=entitlements --sign -` 彻底解决 macOS 客户端修改后闪退问题。
- **CDP 0.1 秒实时热挂载**：自动读取 `DevToolsActivePort` 向正在运行的桌面版窗口实时注入中文界面，无需重启客户端即可生效。

### 🛡️ 核心优化与修复 (Optimizations & Fixes)
- **原版思考保护边界 (`isThinkingContentBoundary`)**：在 [`core/i18n-runtime.js`](./core/i18n-runtime.js) 中将思考折叠框内容区（`div[role="group"]`）设为受保护边界，仅汉化「思考中... / 已思考 XX 秒」标题按钮，彻底杜绝静态词典对原生思考过程的逐词硬翻。
- **无损中文输出规范 (`AGENTS.md`)**：清理 3 倍重复规则注入与多余钩子，仅保留全局插件内唯一一份 [`AGENTS.md`](./plugins/chinese-toolkit/rules/AGENTS.md)——内部推理（`Thinking`）保持原版自然状态，所有面向用户的输出与工具状态提示（`toolAction` / `toolSummary`）100% 使用简体中文。
- **`app.asar` 体积瘦身 75%**：改为始终从官方纯净备份 `app.asar.bak` 解包，配合 `--unpack-dir` 与单源 `agy-i18n-bundle.js` 注入，将打包体积从 `19.1 MB` 降至 `4.8 MB`。
