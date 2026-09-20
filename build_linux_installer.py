import os, tarfile, shutil

base_dir = os.path.dirname(os.path.abspath(__file__))
linux_installer_dir = os.path.join(base_dir, "installers", "linux")
package_root = os.path.join(linux_installer_dir, "suyu-v0.0.4-linux-x64")

if os.path.exists(package_root):
    shutil.rmtree(package_root)
os.makedirs(os.path.join(package_root, "bin"), exist_ok=True)
os.makedirs(os.path.join(package_root, "share", "applications"), exist_ok=True)
os.makedirs(os.path.join(package_root, "share", "icons", "hicolor", "scalable", "apps"), exist_ok=True)
os.makedirs(os.path.join(package_root, "share", "mime", "packages"), exist_ok=True)
os.makedirs(os.path.join(package_root, "share", "metainfo"), exist_ok=True)
os.makedirs(os.path.join(package_root, "udev"), exist_ok=True)

# 1. Extract linux binaries from suyu-linux-x64.tar.gz
linux_tar = os.path.join(linux_installer_dir, "suyu-linux-x64.tar.gz")
print("Extracting Linux binaries...")
with tarfile.open(linux_tar, "r:gz") as tar:
    for member in tar.getmembers():
        if member.name in ["suyu", "suyu-cmd", "./suyu", "./suyu-cmd"]:
            member.name = os.path.basename(member.name)
            tar.extract(member, path=os.path.join(package_root, "bin"))

# 2. Copy desktop integration files from dist/
dist_dir = os.path.join(base_dir, "dist")
shutil.copy2(os.path.join(dist_dir, "dev.suyu_emu.suyu.desktop"), os.path.join(package_root, "share", "applications", "dev.suyu_emu.suyu.desktop"))
shutil.copy2(os.path.join(dist_dir, "suyu.svg"), os.path.join(package_root, "share", "icons", "hicolor", "scalable", "apps", "suyu.svg"))
shutil.copy2(os.path.join(dist_dir, "dev.suyu_emu.suyu.xml"), os.path.join(package_root, "share", "mime", "packages", "dev.suyu_emu.suyu.xml"))
shutil.copy2(os.path.join(dist_dir, "dev.suyu_emu.suyu.metainfo.xml"), os.path.join(package_root, "share", "metainfo", "dev.suyu_emu.suyu.metainfo.xml"))
shutil.copy2(os.path.join(dist_dir, "72-suyu-input.rules"), os.path.join(package_root, "udev", "72-suyu-input.rules"))

# 3. Create install.sh
install_sh_content = """#!/usr/bin/env bash
# suyu v0.0.4 Linux Installer
# Supports system-wide install (sudo) or per-user install (--user)

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

USE_USER=0
if [ "$1" = "--user" ] || [ "$(id -u)" -ne 0 ]; then
    if [ "$1" != "--user" ]; then
        echo "Note: Running as non-root user. Installing to ~/.local (pass sudo for system-wide install)"
    fi
    USE_USER=1
fi

if [ "$USE_USER" -eq 1 ]; then
    PREFIX="${HOME}/.local"
    UDEV_DIR=""
else
    PREFIX="/usr/local"
    UDEV_DIR="/etc/udev/rules.d"
fi

echo "================================================="
echo " Installing suyu v0.0.4 to ${PREFIX}..."
echo "================================================="

# Create target directories
mkdir -p "${PREFIX}/bin"
mkdir -p "${PREFIX}/share/applications"
mkdir -p "${PREFIX}/share/icons/hicolor/scalable/apps"
mkdir -p "${PREFIX}/share/mime/packages"
mkdir -p "${PREFIX}/share/metainfo"

# Install binaries
echo "Installing executables..."
cp -f "${DIR}/bin/suyu" "${PREFIX}/bin/suyu"
chmod +x "${PREFIX}/bin/suyu"

if [ -f "${DIR}/bin/suyu-cmd" ]; then
    cp -f "${DIR}/bin/suyu-cmd" "${PREFIX}/bin/suyu-cmd"
    chmod +x "${PREFIX}/bin/suyu-cmd"
fi

# Install desktop integration
echo "Installing desktop integration & icons..."
cp -f "${DIR}/share/applications/dev.suyu_emu.suyu.desktop" "${PREFIX}/share/applications/dev.suyu_emu.suyu.desktop"
cp -f "${DIR}/share/icons/hicolor/scalable/apps/suyu.svg" "${PREFIX}/share/icons/hicolor/scalable/apps/suyu.svg"
cp -f "${DIR}/share/mime/packages/dev.suyu_emu.suyu.xml" "${PREFIX}/share/mime/packages/dev.suyu_emu.suyu.xml"
cp -f "${DIR}/share/metainfo/dev.suyu_emu.suyu.metainfo.xml" "${PREFIX}/share/metainfo/dev.suyu_emu.suyu.metainfo.xml"

# Update Exec path if installing to non-standard prefix
if [ "$PREFIX" = "${HOME}/.local" ]; then
    sed -i "s|^Exec=suyu|Exec=${HOME}/.local/bin/suyu|g" "${PREFIX}/share/applications/dev.suyu_emu.suyu.desktop"
fi

# Install udev rules for Nintendo Switch Pro Controller & Joy-Cons
if [ -n "$UDEV_DIR" ] && [ -w "$UDEV_DIR" ]; then
    echo "Installing controller udev rules..."
    cp -f "${DIR}/udev/72-suyu-input.rules" "${UDEV_DIR}/72-suyu-input.rules"
    if command -v udevadm >/dev/null 2>&1; then
        udevadm control --reload-rules && udevadm trigger || true
    fi
fi

# Update system databases
echo "Updating desktop & icon caches..."
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "${PREFIX}/share/applications" || true
fi

if command -v update-mime-database >/dev/null 2>&1; then
    update-mime-database "${PREFIX}/share/mime" || true
fi

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "${PREFIX}/share/icons/hicolor" 2>/dev/null || true
fi

echo "================================================="
echo " suyu v0.0.4 installed successfully!"
echo " Launch it from your applications menu or run:"
echo "   ${PREFIX}/bin/suyu"
echo "================================================="
"""

with open(os.path.join(package_root, "install.sh"), "w", encoding="utf-8", newline="\n") as f:
    f.write(install_sh_content)

# 4. Create uninstall.sh
uninstall_sh_content = """#!/usr/bin/env bash
# suyu v0.0.4 Linux Uninstaller

set -e

if [ "$1" = "--user" ] || [ "$(id -u)" -ne 0 ]; then
    PREFIX="${HOME}/.local"
    UDEV_DIR=""
else
    PREFIX="/usr/local"
    UDEV_DIR="/etc/udev/rules.d"
fi

echo "Uninstalling suyu from ${PREFIX}..."
rm -f "${PREFIX}/bin/suyu"
rm -f "${PREFIX}/bin/suyu-cmd"
rm -f "${PREFIX}/share/applications/dev.suyu_emu.suyu.desktop"
rm -f "${PREFIX}/share/icons/hicolor/scalable/apps/suyu.svg"
rm -f "${PREFIX}/share/mime/packages/dev.suyu_emu.suyu.xml"
rm -f "${PREFIX}/share/metainfo/dev.suyu_emu.suyu.metainfo.xml"

if [ -n "$UDEV_DIR" ] && [ -f "${UDEV_DIR}/72-suyu-input.rules" ]; then
    rm -f "${UDEV_DIR}/72-suyu-input.rules"
    if command -v udevadm >/dev/null 2>&1; then
        udevadm control --reload-rules || true
    fi
fi

echo "suyu uninstalled successfully."
"""

with open(os.path.join(package_root, "uninstall.sh"), "w", encoding="utf-8", newline="\n") as f:
    f.write(uninstall_sh_content)

# 5. Pack into suyu-v0.0.4-linux-x64-installer.tar.gz
installer_tar = os.path.join(linux_installer_dir, "suyu-v0.0.4-linux-x64-installer.tar.gz")
def set_permissions(tarinfo):
    if tarinfo.name.endswith(".sh") or "/bin/" in tarinfo.name or tarinfo.name.endswith("suyu") or tarinfo.name.endswith("suyu-cmd"):
        tarinfo.mode = 0o755
    return tarinfo

print("Packaging suyu-v0.0.4-linux-x64-installer.tar.gz...")
with tarfile.open(installer_tar, "w:gz") as tar:
    tar.add(package_root, arcname="suyu-v0.0.4-linux-x64", filter=set_permissions)

print(f"Linux installer ready: {installer_tar} ({os.path.getsize(installer_tar)/(1024*1024):.1f} MB)")
