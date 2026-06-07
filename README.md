# PenguinGPT

<div align="center">
  <img src="https://img.shields.io/badge/Linux-Tauri%20v2-4cc2ff?style=for-the-badge" alt="Linux Tauri v2" />
  <img src="https://img.shields.io/badge/ChatGPT%20Wrapper-Desktop%20App-111827?style=for-the-badge" alt="Desktop app" />
  <img src="https://img.shields.io/github/v/release/dasnai88/PenguinGPT?include_prereleases&style=for-the-badge&label=release" alt="Release" />
</div>

<div align="center">
  <a href="https://github.com/dasnai88/PenguinGPT/stargazers">
    <img src="https://img.shields.io/github/stars/dasnai88/PenguinGPT?style=for-the-badge&logo=github&label=star%20this%20repo" alt="Stars" />
  </a>
  <a href="https://github.com/dasnai88/PenguinGPT/network/members">
    <img src="https://img.shields.io/github/forks/dasnai88/PenguinGPT?style=for-the-badge&logo=github" alt="Forks" />
  </a>
  <a href="https://github.com/dasnai88/PenguinGPT/issues">
    <img src="https://img.shields.io/github/issues/dasnai88/PenguinGPT?style=for-the-badge&logo=github" alt="Issues" />
  </a>
</div>

<div align="center">
  <img src="./assets/readme-hero.svg" alt="PenguinGPT banner" />
</div>

## Overview

PenguinGPT is an unofficial Linux desktop wrapper for `https://chatgpt.com`.

It is built with Rust and Tauri v2 and starts from a local launcher page before opening the official ChatGPT site in a native Linux webview. It does not use the OpenAI API and does not ask for an API key.

## Highlights

- Native Linux desktop experience.
- Minimal local launcher page.
- Opens the official ChatGPT website in a webview.
- AppImage-first packaging.
- Simple install and uninstall scripts.
- No API key flow and no credential interception.

## Widgets

<div align="center">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=dasnai88&repo=PenguinGPT&theme=tokyonight&hide_border=true" alt="PenguinGPT repo card" />
</div>

<div align="center">
  <img src="https://img.shields.io/github/last-commit/dasnai88/PenguinGPT?style=for-the-badge&label=last%20update&color=0f172a" alt="Last update" />
  <img src="https://img.shields.io/github/repo-size/dasnai88/PenguinGPT?style=for-the-badge&label=repo%20size&color=0f172a" alt="Repo size" />
  <img src="https://img.shields.io/badge/language-Rust-ff7043?style=for-the-badge" alt="Language Rust" />
</div>

## Preview

<div align="center">
  <img src="https://img.shields.io/badge/Window%20size-1200x850-0ea5e9?style=for-the-badge" alt="Window size" />
  <img src="https://img.shields.io/badge/Bundle-AppImage-22c55e?style=for-the-badge" alt="AppImage" />
  <img src="https://img.shields.io/badge/Identifier-com.penguingpt.app-f97316?style=for-the-badge" alt="Identifier" />
</div>

## What it does

- Opens `https://chatgpt.com` inside a separate desktop window.
- Starts with a minimal local launcher page so it behaves like a normal desktop app.
- Keeps the session using the standard webview storage used by the platform.
- Builds as a Linux AppImage.
- Uses a minimal frontend and no backend integration with OpenAI.

## What it does not do

- No OpenAI API usage.
- No API key prompt.
- No hidden requests to ChatGPT.
- No login/password interception.
- No cookie, token, or localStorage scraping.
- No bypass of Cloudflare, rate limits, or other protections.

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

## Development

Run the app in development mode:

```bash
npm run tauri dev
```

## Build

Build the AppImage:

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

## Star the project

If you like the project, star it on GitHub:

<div align="center">
  <a href="https://github.com/dasnai88/PenguinGPT/stargazers">
    <img src="https://img.shields.io/badge/Star%20on-GitHub-111827?style=for-the-badge&logo=github" alt="Star on GitHub" />
  </a>
</div>
