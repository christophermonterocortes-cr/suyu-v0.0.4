@echo off
setlocal

echo ====================================================================
echo   suyu v0.0.4 - GitHub Fork and Push Automation
echo ====================================================================
echo.

python "%~dp0authenticate_and_fork.py"

pause
