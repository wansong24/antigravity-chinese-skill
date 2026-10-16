@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "cli.js" cd /d "%~dp0.."

echo ==================================================
echo 🚀 Antigravity 一键中文汉化安装/更新工具 (v4.0.0 - Windows)
echo ==================================================
echo.

where node >nul 2>nul
if %errorlevel% neq 0 (
  echo ❌ 未检测到 Node.js 环境！请先前往 https://nodejs.org 下载安装 Node.js LTS 版本。
  echo.
  pause
  exit /b 1
)

echo 🌐 [云端同步] 正在检查 GitHub 最新中文词库更新...
git fetch origin main --quiet 2>nul
if %errorlevel% equ 0 (
  node -e "const fs=require('fs'),{execSync}=require('child_process');try{const r=JSON.parse(execSync('git show origin/main:dict/zh-CN.json',{encoding:'utf8'})),p='./dict/zh-CN.json',l=JSON.parse(fs.readFileSync(p,'utf8'));let a=0;if(r.exact){l.exact=l.exact||{};for(const[k,v]of Object.entries(r.exact)){if(!(k in l.exact)){l.exact[k]=v;a++;}}}if(a>0){fs.writeFileSync(p,JSON.stringify(l,null,2)+'\n','utf8');console.log('   ✅ 已从 GitHub 增量同步 '+a+' 条最新翻译词条！');}else{console.log('   ✅ 本地翻译词库已是最新版本。');}}catch(e){console.log('   ℹ️ 跳过云端词库合并，使用当前本地词库。');}"
) else (
  echo    ℹ️ 直接使用当前内置最新中文词库。
)
echo.

node "./cli.js" install --with-plugin
echo.
pause
