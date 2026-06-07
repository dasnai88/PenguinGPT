# PenguinGPT

Unofficial ChatGPT desktop wrapper for Linux.

PenguinGPT is not an official OpenAI client. It does not use the OpenAI API, does not ask for an API key, and does not proxy or intercept ChatGPT credentials, cookies, session tokens, or localStorage. It is a Rust + Tauri v2 desktop wrapper that starts from a local launcher page and then opens the official site at `https://chatgpt.com` in a native Linux webview.

## What it does

- Opens `https://chatgpt.com` inside a separate desktop window.
- Starts with a minimal local launcher page so it behaves like a normal desktop app.
- Keeps the session using the standard webview storage used by the platform.
- Builds as a Linux AppImage.
- Uses a minimal frontend and no backend integration with OpenAI.

## What it does not do

- No OpenAI API usage.
- No Codex/API tokens are used at runtime.
- No API key prompt.
- No hidden requests to ChatGPT.
- No login/password interception.
- No cookie, token, or localStorage scraping.
- No bypass of Cloudflare, rate limits, or any other protection.

## Requirements for Arch Linux / CachyOS

Install the system packages first:

```bash
sudo pacman -S --needed base-devel curl wget file openssl appmenu-gtk-module gtk3 libappindicator-gtk3 librsvg webkit2gtk-4.1 nodejs npm rust cargo
```

## Install

From the project root:

```bash
npm install
```

## Run in development

```bash
npm run tauri dev
```

## Build AppImage

```bash
npm run tauri build
```

The bundled output is configured for AppImage only.
The npm Tauri script sets `APPIMAGE_EXTRACT_AND_RUN=1` and `NO_STRIP=1` so the AppImage toolchain can run even on systems without `libfuse.so.2` and without strip-related `.relr.dyn` failures.

## Install and uninstall

Use the single installer CLI for all install and uninstall operations:

```bash
bash penguingpt-installer.sh --help
```

Local install:

```bash
bash penguingpt-installer.sh install
```

Local uninstall:

```bash
bash penguingpt-installer.sh uninstall
```

System-wide install:

```bash
sudo bash penguingpt-installer.sh system-install
```

System-wide uninstall:

```bash
sudo bash penguingpt-installer.sh system-uninstall
```

You can also pass a specific AppImage path after the command if you do not want the script to auto-discover the latest build:

```bash
bash penguingpt-installer.sh install src-tauri/target/release/bundle/appimage/PenguinGPT_0.1.0_amd64.AppImage
sudo bash penguingpt-installer.sh system-install src-tauri/target/release/bundle/appimage/PenguinGPT_0.1.0_amd64.AppImage
```

The local installer copies:

- the AppImage to `~/.local/share/penguingpt/PenguinGPT.AppImage`
- the desktop entry to `~/.local/share/applications/com.penguingpt.app.desktop`
- the icon to `~/.local/share/icons/hicolor/512x512/apps/penguingpt.png`

The system installer copies:

- the AppImage to `/opt/penguingpt/PenguinGPT.AppImage`
- the desktop entry to `/usr/share/applications/com.penguingpt.app.desktop`
- the icon to `/usr/share/icons/hicolor/512x512/apps/penguingpt.png`

Compatibility wrappers remain available for convenience:

- `bash install.sh`
- `bash uninstall.sh`
- `sudo bash install-system.sh`
- `sudo bash uninstall-system.sh`

## Desktop integration

The AppImage bundle includes a desktop entry and icon inside standard Linux paths:

- `/usr/share/applications/penguingpt.desktop`
- `/usr/share/applications/com.penguingpt.app.desktop`
- `/usr/share/icons/hicolor/512x512/apps/penguingpt.png`

That means desktop environments and AppImage integration tools can recognize PenguinGPT like a normal installed app after the AppImage is launched or integrated.

If you prefer a manual install, the generated desktop file and icon are also suitable as the basis for a `.desktop` registration in `~/.local/share/applications`.

The current PenguinGPT logo is the strict dark-blue penguin mark shipped in `src-tauri/icons/icon-source.svg` and rendered into the Tauri icon set.

## Project notes

- App name: `PenguinGPT`
- Description: `Unofficial ChatGPT desktop wrapper for Linux`
- Identifier: `com.penguingpt.app`
- Main window size: `1200x850`
- Window title: `PenguinGPT`
- Start URL: `https://chatgpt.com`
- Logo: custom PenguinGPT penguin mark
- Desktop entry: bundled into the AppImage for Linux integration

The app uses the official ChatGPT website and the normal login flow provided by that site.
