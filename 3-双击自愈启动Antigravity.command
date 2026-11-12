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

if command -v node >/dev/null 2>&1; then
  NODE_CMD="node"
elif [ -x "/Applications/Antigravity.app/Contents/MacOS/Antigravity" ]; then
  export ELECTRON_RUN_AS_NODE=1
  NODE_CMD="/Applications/Antigravity.app/Contents/MacOS/Antigravity"
else
  NODE_CMD="node"
fi

echo "=================================================="
echo "✨ Antigravity 自愈汉化启动器 (v4.2.0 - macOS)"
echo "=================================================="
"$NODE_CMD" "./cli.js" launch --no-kill
echo ""
read -n 1 -s -r -p "按任意键关闭此窗口..."
echo ""
