import os, urllib.request, tarfile, shutil

base_dir = r"C:\Users\CHRISTOPHER\Downloads\suyu-v0.0.4"
linux_dir = os.path.join(base_dir, "installers", "linux")
android_dir = os.path.join(base_dir, "installers", "android")

os.makedirs(linux_dir, exist_ok=True)
os.makedirs(android_dir, exist_ok=True)

# 1. Download Android APKs
apks = {
    "app-mainline-release.apk": "suyu-v0.0.4-android-mainline.apk",
    "app-legacy-release.apk": "suyu-v0.0.4-android-legacy.apk",
    "app-chromeOS-release.apk": "suyu-v0.0.4-android-chromeOS.apk",
    "app-genshinSpoof-release.apk": "suyu-v0.0.4-android-genshinSpoof.apk",
}

for remote_name, local_name in apks.items():
    out_path = os.path.join(android_dir, local_name)
    if not os.path.exists(out_path):
        url = f"https://github.com/suyu-emu/suyu-v0.0.4/releases/download/v0.04-latest/{remote_name}"
        print(f"Downloading {local_name}...")
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req) as resp, open(out_path, "wb") as f:
            f.write(resp.read())
        print(f"Saved {local_name} ({os.path.getsize(out_path)/(1024*1024):.1f} MB)")
    else:
        print(f"{local_name} already exists.")

# 2. Download Linux tar.gz
linux_tar = os.path.join(linux_dir, "suyu-linux-x64.tar.gz")
if not os.path.exists(linux_tar):
    url = "https://github.com/suyu-emu/suyu-v0.0.4/releases/download/v0.04-latest/suyu-linux-x64.tar.gz"
    print("Downloading suyu-linux-x64.tar.gz...")
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req) as resp, open(linux_tar, "wb") as f:
        f.write(resp.read())
    print("Downloaded suyu-linux-x64.tar.gz")

print("Download complete!")
