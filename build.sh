#!/bin/bash -e
DIST_DIR="./dist"
DIST_APP_DIR="${DIST_DIR}/Firefox Portable.app"
CACHE_DIR="./cache"
FIREFOX_DOWNLOAD_URL="https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=ja-JP-mac"

## 出力先の準備
rm -rf "$DIST_DIR"
mkdir -p "${DIST_APP_DIR}/Contents"
mkdir "${DIST_APP_DIR}/Contents/MacOS"
mkdir "${DIST_APP_DIR}/Contents/Resources"

## plistを配置
cp ./resources/Info.plist "${DIST_APP_DIR}/Contents/Info.plist"

## Firefox.dmgをダウンロード
if [[ ! -e "${CACHE_DIR}/firefox.dmg" ]]; then
    mkdir "${CACHE_DIR}"
    curl -Ss -o "${CACHE_DIR}/firefox.dmg" -L "${FIREFOX_DOWNLOAD_URL}"
fi

## Firefox.appを抽出して配置
hdiutil attach "${CACHE_DIR}/firefox.dmg"
ditto \
  /Volumes/Firefox/Firefox.app \
  "${DIST_APP_DIR}/Contents/Resources/Firefox.app"
hdiutil detach /Volumes/Firefox

## アイコンを配置
cp \
  "${DIST_APP_DIR}/Contents/Resources/Firefox.app/Contents/Resources/firefox.icns" \
  "${DIST_APP_DIR}/Contents/Resources/firefox.icns"

## firefox_launcherをビルド
( 
  cd ./firefox_launcher
  rustup target add aarch64-apple-darwin x86_64-apple-darwin
  cargo clean
  cargo build --release --target aarch64-apple-darwin --target x86_64-apple-darwin
)

## Universal Binaryを作成して配備
lipo \
  -create \
  ./firefox_launcher/target/aarch64-apple-darwin/release/firefox_launcher \
  ./firefox_launcher/target/x86_64-apple-darwin/release/firefox_launcher \
  -output "${DIST_APP_DIR}/Contents/MacOS/firefox_launcher"

## Profileディレクトリを作成
mkdir "${DIST_APP_DIR}/Contents/Resources/Profile"
