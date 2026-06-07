# Maintainer: PenguinGPT contributors

pkgname=penguingpt-git
pkgver=0.1.0.r0.g0
pkgrel=1
pkgdesc="Unofficial ChatGPT desktop wrapper for Linux"
arch=('x86_64')
url="https://github.com/dasnai88/PenguinGPT"
license=('MIT')
depends=(
  'appmenu-gtk-module'
  'gtk3'
  'libappindicator-gtk3'
  'librsvg'
  'openssl'
  'webkit2gtk-4.1'
)
makedepends=(
  'cargo'
  'curl'
  'file'
  'git'
  'nodejs'
  'npm'
  'rust'
  'wget'
)
provides=('penguingpt')
conflicts=('penguingpt')
source=("git+https://github.com/dasnai88/PenguinGPT.git")
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/PenguinGPT"

  local version
  version="$(git describe --long --tags --abbrev=7 2>/dev/null || true)"

  if [[ -n "$version" ]]; then
    printf '%s\n' "${version#v}" | sed 's/-/./g'
    return
  fi

  printf '0.1.0.r%s.g%s\n' "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
  cd "$srcdir/PenguinGPT"
  npm ci
}

build() {
  cd "$srcdir/PenguinGPT"
  APPIMAGE_EXTRACT_AND_RUN=1 NO_STRIP=1 npm run tauri build
}

package() {
  cd "$srcdir/PenguinGPT"

  local appimage
  appimage="$(find src-tauri/target/release/bundle/appimage -maxdepth 1 -name 'PenguinGPT_*.AppImage' | sort | tail -n 1)"

  install -Dm755 "$appimage" "$pkgdir/opt/penguingpt/PenguinGPT.AppImage"

  cat > "$pkgdir/usr/bin/penguingpt" <<'EOF'
#!/bin/bash
exec /opt/penguingpt/PenguinGPT.AppImage "$@"
EOF
  chmod 755 "$pkgdir/usr/bin/penguingpt"

  install -Dm644 src-tauri/desktop/PenguinGPT.desktop "$pkgdir/usr/share/applications/com.penguingpt.app.desktop"
  install -Dm644 src-tauri/icons/icon.png "$pkgdir/usr/share/icons/hicolor/512x512/apps/penguingpt.png"
}
