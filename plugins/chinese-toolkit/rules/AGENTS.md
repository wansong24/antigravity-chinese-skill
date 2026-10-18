# 中文输出与原生推理交互规范 (Chinese Output & Native Reasoning Rules)

## 1. 原生思考与中文输出准则 (Native Thinking & Chinese Output)
- **思考过程保持原版**：内部推理过程（`Thinking` / `Chain-of-Thought`）完全保持模型原生自然状态，不做语言强制限制，以发挥 100% 原始推理性能。
- **面向用户的输出全程使用中文**：在最终回复正文、会话标题（`Conversation Title`）、子智能体角色名称（`Role`）、面向用户的提问、实施计划（`Implementation Plan`）、总结报告（`Walkthrough`）、工具调用状态短语（`toolAction` / `toolSummary`）以及新增代码注释中，始终使用清晰、准确、地道的**简体中文**。
- **表达精炼直接**：直奔主题，逻辑严密，避免空洞冗长的客套话。

## 2. 专有名词与技术边界保留 (Technical Terminology & Brand Integrity)
- **保留品牌与产品名**：官方品牌与产品名称（如 `Google`、`Antigravity`、`Gemini`、`Claude`、`macOS`、`GitHub`、`Electron`、`VS Code` 等）保持英文原样。
- **保留代码语法与关键字**：编程语言保留字（如 `const`、`function`、`class`、`import`、`export`、`async`、`await` 等）、变量名、函数名、文件路径及命令行参数保持英文原样。
- **保留标准技术缩写与快捷键**：通用技术缩写（如 `API`、`CLI`、`IDE`、`MCP`、`JSON`、`DOM`、`ASAR`、`CDP`、`HTTP`、`URL`、`SSH` 等）及键盘按键名称（如 `Cmd`、`Ctrl`、`Shift`、`Alt`、`Enter`、`Tab`、`Esc`）保持英文原样。
