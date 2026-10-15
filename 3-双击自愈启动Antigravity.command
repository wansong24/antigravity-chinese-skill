#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/cli.js" ]; then
  cd "$SCRIPT_DIR"
else
  cd "$SCRIPT_DIR/.."
fi

echo "=================================================="
echo "✨ Antigravity 自愈汉化启动器 (v4.0.0 - macOS)"
echo "=================================================="
node "./cli.js" launch --no-kill
echo ""
read -n 1 -s -r -p "按任意键关闭此窗口..."
echo ""
