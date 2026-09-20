#!/usr/bin/env bash
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
