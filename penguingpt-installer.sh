#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="PenguinGPT"
APP_ID="com.penguingpt.app"
APPIMAGE_GLOB="$SCRIPT_DIR/src-tauri/target/release/bundle/appimage/PenguinGPT_*.AppImage"

usage() {
  cat <<EOF
Usage:
  $(basename "$0") install [path-to-AppImage]
  $(basename "$0") uninstall
  $(basename "$0") system-install [path-to-AppImage]
  $(basename "$0") system-uninstall

Commands:
  install          Install into the current user's profile under ~/.local/share
  uninstall        Remove the current user's local installation
  system-install   Install under /opt and /usr/share (requires root)
  system-uninstall Remove the system-wide installation (requires root)
EOF
}

find_default_appimage() {
  local glob="$1"
  shopt -s nullglob
  local candidates=($glob)
  shopt -u nullglob
  if [[ ${#candidates[@]} -eq 0 ]]; then
    return 1
  fi
  printf '%s\n' "${candidates[-1]}"
}

write_desktop_file() {
  local target="$1"
  local exec_path="$2"
  cat > "$target" <<EOF
[Desktop Entry]
Type=Application
Name=$APP_NAME
Comment=Unofficial ChatGPT desktop wrapper for Linux
GenericName=ChatGPT Desktop Wrapper
Exec=$exec_path %U
Icon=penguingpt
Terminal=false
Categories=Network;InstantMessaging;Chat;Utility;
Keywords=ChatGPT;OpenAI;Penguin;AI;Chat;
StartupNotify=true
StartupWMClass=PenguinGPT
X-GNOME-WMClass=PenguinGPT
EOF
}

refresh_user_caches() {
  local desktop_dir="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
  local icon_theme_dir="${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor"
  if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$desktop_dir" >/dev/null 2>&1 || true
  fi
  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "$icon_theme_dir" >/dev/null 2>&1 || true
  fi
}

refresh_system_caches() {
  if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
  fi
  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t /usr/share/icons/hicolor >/dev/null 2>&1 || true
  fi
}

install_user() {
  local source_appimage="${1:-}"
  local install_base="${XDG_DATA_HOME:-$HOME/.local/share}/penguingpt"
  local appimage_target="$install_base/PenguinGPT.AppImage"
  local icon_theme_dir="${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor"
  local icon_target="$icon_theme_dir/512x512/apps/penguingpt.png"
  local desktop_dir="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
  local desktop_target="$desktop_dir/$APP_ID.desktop"

  if [[ -z "$source_appimage" ]]; then
    source_appimage="$(find_default_appimage "$APPIMAGE_GLOB" || true)"
  fi

  if [[ -z "${source_appimage:-}" ]]; then
    echo "No built AppImage found."
    echo "Run: npm run tauri build"
    echo "Or pass the AppImage path as the second argument."
    exit 1
  fi

  if [[ ! -f "$source_appimage" ]]; then
    echo "AppImage not found: $source_appimage"
    exit 1
  fi

  mkdir -p "$install_base" "$icon_theme_dir/512x512/apps" "$desktop_dir"
  install -m 755 "$source_appimage" "$appimage_target"
  install -m 644 "$SCRIPT_DIR/src-tauri/icons/icon.png" "$icon_target"
  write_desktop_file "$desktop_target" "$appimage_target"
  refresh_user_caches

  echo "Installed PenguinGPT to:"
  echo "  $appimage_target"
  echo "  $desktop_target"
  echo "  $icon_target"
}

uninstall_user() {
  local install_base="${XDG_DATA_HOME:-$HOME/.local/share}/penguingpt"
  local appimage_target="$install_base/PenguinGPT.AppImage"
  local icon_target="${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/512x512/apps/penguingpt.png"
  local desktop_target="${XDG_DATA_HOME:-$HOME/.local/share}/applications/$APP_ID.desktop"

  rm -f "$appimage_target" "$icon_target" "$desktop_target"
  rmdir --ignore-fail-on-non-empty "$install_base" 2>/dev/null || true
  refresh_user_caches
  echo "PenguinGPT user installation removed."
}

require_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "Run this command as root, for example: sudo bash $0 system-install"
    exit 1
  fi
}

install_system() {
  require_root

  local source_appimage="${1:-}"
  local system_base="/opt/penguingpt"
  local appimage_target="$system_base/PenguinGPT.AppImage"
  local icon_target="/usr/share/icons/hicolor/512x512/apps/penguingpt.png"
  local desktop_target="/usr/share/applications/$APP_ID.desktop"

  if [[ -z "$source_appimage" ]]; then
    source_appimage="$(find_default_appimage "$APPIMAGE_GLOB" || true)"
  fi

  if [[ -z "${source_appimage:-}" ]]; then
    echo "No built AppImage found."
    echo "Run: npm run tauri build"
    echo "Or pass the AppImage path as the third argument."
    exit 1
  fi

  if [[ ! -f "$source_appimage" ]]; then
    echo "AppImage not found: $source_appimage"
    exit 1
  fi

  install -d -m 755 "$system_base" /usr/share/icons/hicolor/512x512/apps /usr/share/applications
  install -m 755 "$source_appimage" "$appimage_target"
  install -m 644 "$SCRIPT_DIR/src-tauri/icons/icon.png" "$icon_target"
  write_desktop_file "$desktop_target" "$appimage_target"
  refresh_system_caches

  echo "Installed PenguinGPT system-wide to:"
  echo "  $appimage_target"
  echo "  $desktop_target"
  echo "  $icon_target"
}

uninstall_system() {
  require_root

  local system_base="/opt/penguingpt"
  local appimage_target="$system_base/PenguinGPT.AppImage"
  local desktop_target="/usr/share/applications/$APP_ID.desktop"
  local icon_target="/usr/share/icons/hicolor/512x512/apps/penguingpt.png"

  rm -f "$appimage_target" "$desktop_target" "$icon_target"
  rmdir --ignore-fail-on-non-empty "$system_base" 2>/dev/null || true
  refresh_system_caches
  echo "PenguinGPT system installation removed."
}

case "${1:-}" in
  install)
    install_user "${2:-}"
    ;;
  uninstall)
    uninstall_user
    ;;
  system-install)
    install_system "${2:-}"
    ;;
  system-uninstall)
    uninstall_system
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    echo "Unknown command: $1"
    echo
    usage
    exit 1
    ;;
esac
