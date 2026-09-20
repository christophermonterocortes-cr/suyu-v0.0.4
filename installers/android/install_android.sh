#!/usr/bin/env bash
# suyu v0.0.4 Android ADB Installer

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================================"
echo "   suyu v0.0.4 Android Installer (ADB)"
echo "============================================================"
echo ""

if ! command -v adb >/dev/null 2>&1; then
    echo "[NOTE] 'adb' command not found."
    echo "Please copy the APK directly to your device or install android-tools:"
    echo "  sudo apt install adb   (Ubuntu/Debian)"
    echo "  brew install android-platform-tools (macOS)"
    echo ""
    echo "APK File: ${DIR}/suyu-v0.0.4-android-mainline.apk"
    exit 1
fi

echo "Connected devices:"
adb devices
echo ""

echo "Select APK to install:"
echo "  [1] Mainline (Recommended for Android 12+ / Snapdragon/Mali)"
echo "  [2] Legacy (Android 11 and older)"
echo "  [3] ChromeOS (Chromebooks)"
echo "  [4] Genshin Spoof (Performance profile bypass)"
echo ""
read -r -p "Select option (1-4, default 1): " choice
choice="${choice:-1}"

case "$choice" in
    2) APK="suyu-v0.0.4-android-legacy.apk" ;;
    3) APK="suyu-v0.0.4-android-chromeOS.apk" ;;
    4) APK="suyu-v0.0.4-android-genshinSpoof.apk" ;;
    *) APK="suyu-v0.0.4-android-mainline.apk" ;;
esac

echo ""
echo "Installing ${APK}..."
adb install -r "${DIR}/${APK}"

if [ $? -eq 0 ]; then
    echo ""
    echo "[SUCCESS] suyu v0.0.4 successfully installed on your device!"
else
    echo ""
    echo "[ERROR] Installation failed. Ensure your device is unlocked and USB Debugging is accepted."
fi
