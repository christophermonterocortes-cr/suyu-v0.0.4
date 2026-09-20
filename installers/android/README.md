# suyu v0.0.4 — Android Installation Guide

This folder contains the official Android installation packages (APKs) for **suyu v0.0.4**.

---

## 📱 Available APK Builds

| APK File | Recommended For | Description |
| :--- | :--- | :--- |
| **`suyu-v0.0.4-android-mainline.apk`** | **Most Users (Recommended)** | Standard release for Android 12, 13, 14+ on modern Qualcomm Snapdragon & ARM Mali GPUs. |
| **`suyu-v0.0.4-android-legacy.apk`** | Older Devices | Targeted for devices running Android 11 or older with legacy storage access permissions. |
| **`suyu-v0.0.4-android-chromeOS.apk`** | Chromebooks / Tablets | Keyboard, mouse, and window management optimizations for ChromeOS. |
| **`suyu-v0.0.4-android-genshinSpoof.apk`** | Throttling Bypass | Identifies as Genshin Impact to bypass vendor thermal/GPU throttling on certain OEMs (Samsung, Xiaomi). |

---

## 🚀 How to Install

### Method 1: Sideload Directly on Phone (Easiest)
1. Transfer the `.apk` file (e.g. `suyu-v0.0.4-android-mainline.apk`) to your phone via USB cable, Google Drive, or local download.
2. Open your phone's **Files / File Manager** app and tap the `.apk`.
3. If prompted, toggle **"Allow from this source"** in your phone's Settings to allow sideloading.
4. Tap **Install**.

### Method 2: One-Click ADB Install via PC (USB)
1. Enable **Developer Options** and **USB Debugging** on your phone.
2. Connect your phone to your PC via USB cable.
3. On Windows: Double-click `install_android.bat`.
4. On Linux/macOS: Run `./install_android.sh`.
