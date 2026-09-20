@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo   suyu v0.0.4 Android Installer (ADB)
echo ============================================================
echo.

where adb >nul 2>nul
if errorlevel 1 (
    echo [NOTE] 'adb' was not found in your PATH.
    echo If your Android device is connected to your PC via USB with USB Debugging enabled,
    echo make sure the Android Platform Tools (adb.exe) are installed.
    echo.
    echo Alternatively, you can copy the APK file directly to your phone:
    echo   %~dp0suyu-v0.0.4-android-mainline.apk
    echo and open it in your phone's File Manager to install.
    echo.
    pause
    exit /b 1
)

echo Checking for connected Android devices...
adb devices
echo.

echo Which APK would you like to install?
echo   [1] Mainline (Recommended for Android 12+ / modern Snapdragon/Mali devices)
echo   [2] Legacy (For Android 11 and older devices)
echo   [3] ChromeOS (Optimized for Chromebooks)
echo   [4] Genshin Spoof (Performance profile bypass)
echo.
set /p choice="Select an option (1-4, default 1): "
if "%choice%"=="" set choice=1

set "APK=suyu-v0.0.4-android-mainline.apk"
if "%choice%"=="2" set "APK=suyu-v0.0.4-android-legacy.apk"
if "%choice%"=="3" set "APK=suyu-v0.0.4-android-chromeOS.apk"
if "%choice%"=="4" set "APK=suyu-v0.0.4-android-genshinSpoof.apk"

echo.
echo Installing %APK% to your device...
adb install -r "%~dp0%APK%"
if errorlevel 1 (
    echo [ERROR] ADB installation failed. Make sure your device is unlocked and USB Debugging is authorized.
) else (
    echo.
    echo [SUCCESS] suyu v0.0.4 has been installed on your Android device!
)

echo.
pause
