#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPIMAGE_GLOB="$SCRIPT_DIR/src-tauri/target/release/bundle/appimage/PenguinGPT_*.AppImage"

find_default_appimage() {
  shopt -s nullglob
  local candidates=($APPIMAGE_GLOB)
  shopt -u nullglob

  if [[ ${#candidates[@]} -eq 0 ]]; then
    return 1
  fi

  printf '%s\n' "${candidates[-1]}"
}

build_appimage_if_needed() {
  local appimage=""
  appimage="$(find_default_appimage 2>/dev/null || true)"

  if [[ -n "$appimage" ]]; then
    printf '%s\n' "$appimage"
    return 0
  fi

  if [[ ! -d "$SCRIPT_DIR/node_modules" ]]; then
    echo "Installing npm dependencies..."
    (cd "$SCRIPT_DIR" && npm install)
  fi

  echo "Building PenguinGPT..."
  (cd "$SCRIPT_DIR" && npm run tauri build)

  appimage="$(find_default_appimage)"
  printf '%s\n' "$appimage"
}

main() {
  local appimage
  appimage="$(build_appimage_if_needed)"
  exec "$SCRIPT_DIR/penguingpt-installer.sh" install "$appimage"
}

main "$@"
