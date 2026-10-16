@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "cli.js" cd /d "%~dp0.."

echo ==================================================
echo 🔍 Antigravity 中文汉化状态检查工具 (v4.0.0 - Windows)
echo ==================================================
echo.
node "./cli.js" status
echo.
pause
