@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "cli.js" cd /d "%~dp0.."

echo ==================================================
echo 🔄 Antigravity 一键卸载汉化并还原英文原版 (v4.0.0 - Windows)
echo ==================================================
node "./cli.js" restore
echo.
pause
