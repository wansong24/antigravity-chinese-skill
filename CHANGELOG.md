# 版本更新日志 (Changelog)

## v4.1.0 (2026-11-12)

### ✨ 新增功能 (Features)
- **macOS 固定证书签名与 TCC 权限跨版本永久保留 (`resolveMacSigningIdentity`)**：
  - 自动探测本机钥匙串中的开发者代码签名证书（如 `Apple Development` / `Developer ID`），优先使用固定证书对 `Antigravity.app` 及所有 `Helper` 进程签名；
  - 将系统 `TCC` 权限校验规则从每次升级必变的临时哈希（`cdhash`）升级为固定证书身份校验，彻底解决客户端升级并重签汉化后「**完全磁盘访问权限**」（如从微信直接拖拽图片提示 `无效的媒体文件`）与「**辅助功能**」（如 `agent-desktop` 无障碍控制）失效的问题；
  - 支持环境变量 `AGY_CODESIGN_IDENTITY` 自定义签名身份，并在无证书环境下自动平滑回退至 `Ad-hoc (-)` 签名。
- **全面适配 Antigravity `2.29.x` ~ `2.31.0` 最新版本（新增 700+ 词条与动态正则）**：
  - 完整汉化 `2.30.0` / `2.31.0` 新增的 **协调器 (`Coordinators` / `New Coordinator`)**、**随手问 (`Ask /btw` 侧边快速问答浮窗)**、**语音转录摘要 (`Voice Transcript Summary`)**、**无障碍模式 (`Accessibility Mode`)**、**通知增强 (`Notifications`)** 以及 **云端工作区 (`Cloud Workspaces`)** 全部界面文案。
- **CDP 词库纪元热重载引擎 (`__AGY_HOT_RELOAD_DICT__`)**：
  - 在 [`core/i18n-runtime.js`](./core/i18n-runtime.js) 中引入 `engineEpoch` 纪元属性隔离与 `requestAnimationFrame` 队列去重，热更新词库时无需刷新窗口即可立即重扫并替换已渲染 DOM 节点。
- **Gemini 桌面版内嵌 Antigravity 联动汉化 (`core/gemini-hub-patch.py`)**：
  - 支持在 macOS 下自动检测并为 `Gemini.app` 内嵌的 `agy` 二进制资源包同步注入中文界面。

---

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
