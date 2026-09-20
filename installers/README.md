# suyu v0.0.4 — Multiplatform Installers

This directory contains complete installation packages for **Windows**, **Linux**, and **Android**.

---

## 🪟 Windows Installer
- **File**: `installers\windows\suyu-v0.0.4-windows-x64-setup.exe`
- **Type**: Native Inno Setup Installer
- **Features**:
  - Automatically installs `suyu.exe` and `suyu-cmd.exe` with bundled Qt 6.7 DLLs and plugins.
  - Adds Start Menu and Desktop shortcuts.
  - Associates Nintendo Switch files (`.nsp`, `.xci`).
  - Creates a clean uninstaller in Windows Settings / Control Panel (Add or Remove Programs).
- **Portable Alternative**: `dist_bin\` contains the portable folder ready to run without installation.

---

## 🐧 Linux Installer
- **File**: `installers\linux\suyu-v0.0.4-linux-x64-installer.tar.gz`
- **Folder**: `installers\linux\suyu-v0.0.4-linux-x64\`
- **Features**:
  - `install.sh`: Installs `suyu` and `suyu-cmd` system-wide (`/usr/local/bin`) or per-user (`~/.local/bin` with `--user`, ideal for Steam Deck / SteamOS).
  - Installs high-resolution SVG icon (`suyu.svg`) and `.desktop` entry (`dev.suyu_emu.suyu.desktop`).
  - Installs Nintendo Switch MIME file type associations.
  - Installs udev rules (`72-suyu-input.rules`) for Switch Pro Controller & Joy-Cons.
  - `uninstall.sh`: One-command uninstaller.

---

## 📱 Android Installer
- **Directory**: `installers\android\`
- **APKs**:
  - `suyu-v0.0.4-android-mainline.apk` (Recommended standard build)
  - `suyu-v0.0.4-android-legacy.apk` (Android 11 and older)
  - `suyu-v0.0.4-android-chromeOS.apk` (Chromebooks)
  - `suyu-v0.0.4-android-genshinSpoof.apk` (Performance throttling bypass)
- **Install Scripts**:
  - `install_android.bat` (Windows 1-click ADB installer)
  - `install_android.sh` (Linux/macOS 1-click ADB installer)
