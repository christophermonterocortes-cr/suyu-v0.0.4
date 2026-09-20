#!/usr/bin/env bash
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
