@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

echo ====================================================================
echo Installing Visual Studio 2022 C++ Build Tools (MSVC v143 + WinSDK)...
echo ====================================================================
cd /d "%~dp0\build-prerequisites"
echo Running vs_BuildTools.exe (this may take a few minutes)...
vs_BuildTools.exe --passive --wait --norestart --nocache --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended

echo ====================================================================
echo Installing Vulkan SDK...
echo ====================================================================
echo Running vulkan-sdk.exe...
vulkan-sdk.exe --accept-licenses --default-answer --confirm-command install

echo ====================================================================
echo Prerequisites installed successfully!
echo You can now run build_suyu.bat to compile suyu.
echo ====================================================================
pause
