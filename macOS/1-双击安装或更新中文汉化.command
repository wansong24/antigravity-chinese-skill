#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.volta/bin:$HOME/.hermes/node/bin:$PATH"
if [ -d "$HOME/.nvm/versions/node" ]; then
  NVM_LATEST="$(ls -1 "$HOME/.nvm/versions/node" 2>/dev/null | tail -n 1)"
  [ -n "$NVM_LATEST" ] && export PATH="$HOME/.nvm/versions/node/$NVM_LATEST/bin:$PATH"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/cli.js" ]; then
  cd "$SCRIPT_DIR"
else
  cd "$SCRIPT_DIR/.."
fi

# 自动移除 macOS 跨设备传输可能附带的隔离属性 (Quarantine)
xattr -cr . 2>/dev/null || true

if command -v node >/dev/null 2>&1; then
  NODE_CMD="node"
elif [ -x "/Applications/Antigravity.app/Contents/MacOS/Antigravity" ]; then
  export ELECTRON_RUN_AS_NODE=1
  NODE_CMD="/Applications/Antigravity.app/Contents/MacOS/Antigravity"
else
  echo "❌ 未检测到 Node.js 环境，也未找到 /Applications/Antigravity.app"
  read -n 1 -s -r -p "按任意键关闭此窗口..."
  exit 1
fi

echo "=================================================="
echo "🚀 Antigravity 一键中文汉化安装/更新工具 (v4.2.0 - macOS)"
echo "=================================================="

echo "🌐 [云端同步] 正在检查 GitHub 最新中文词库更新..."
if git fetch origin main --quiet 2>/dev/null; then
  "$NODE_CMD" -e '
    const fs = require("fs");
    const { execSync } = require("child_process");
    try {
      const remoteJson = execSync("git show origin/main:dict/zh-CN.json", { encoding: "utf8" });
      const remoteData = JSON.parse(remoteJson);
      const localPath = "./dict/zh-CN.json";
      const localData = JSON.parse(fs.readFileSync(localPath, "utf8"));
      let added = 0;
      if (remoteData.exact && typeof remoteData.exact === "object") {
        localData.exact = localData.exact || {};
        for (const [k, v] of Object.entries(remoteData.exact)) {
          if (!(k in localData.exact)) {
            localData.exact[k] = v;
            added++;
          }
        }
      }
      if (added > 0) {
        fs.writeFileSync(localPath, JSON.stringify(localData, null, 2) + "\n", "utf8");
        console.log("   ✅ 已从 GitHub 增量同步 " + added + " 条最新翻译词条！");
      } else {
        console.log("   ✅ 本地翻译词库已是最新版本。");
      }
    } catch (e) {
      console.log("   ℹ️ 跳过云端词库合并，使用当前本地词库。");
    }
  '
else
  echo "   ℹ️ 当前离线或无法连接 GitHub，直接使用本地内置最新词库。"
fi
echo ""

"$NODE_CMD" "./cli.js" install --with-plugin --no-kill
sleep 1
echo ""
read -n 1 -s -r -p "按任意键关闭此窗口..."
echo ""
