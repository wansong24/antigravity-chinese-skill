@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "cli.js" cd /d "%~dp0.."

echo ==================================================
echo ✨ Antigravity 自愈汉化启动器 (v4.0.0 - Windows)
echo ==================================================
node "./cli.js" launch
echo.
pause
