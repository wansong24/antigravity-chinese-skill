#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/cli.js" ]; then
  cd "$SCRIPT_DIR"
else
  cd "$SCRIPT_DIR/.."
fi

echo "=================================================="
echo "🚀 Antigravity 一键中文汉化安装/更新工具 (v4.0.0 - macOS)"
echo "=================================================="

echo "🌐 [云端同步] 正在检查 GitHub 最新中文词库更新..."
if git fetch origin main --quiet 2>/dev/null; then
  node -e '
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
  echo "   ℹ️ 当前离线或无法连接 GitHub，直接使用本地词库。"
fi
echo ""

node "./cli.js" install --with-plugin --no-kill
sleep 1
echo ""
read -n 1 -s -r -p "按任意键关闭此窗口..."
echo ""
