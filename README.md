# FirefoxPortableKit

macOS 向けの Firefox ポータブルアプリを作成するツールキットです。

以下の構成の app を作成します。

```
Firefox Portable.app/Contents
├── Info.plist
├── MacOS
│   └── firefox_launcher
└── Resources
   ├── Firefox.app
   ├── firefox.icns
   └── Profile
```

app 内に Firefox の実体と[Profile](https://support.mozilla.org/ja/kb/profiles-where-firefox-stores-user-data)を保持し、`firefox_launcher`によって起動します。

## Requirement

- Rust
- Command line tools for Xcode

## Usage

以下のコマンドを実行することで、`./dist`ディレクトリ配下に`Firefox Portable.app`が生成されます。

```sh
$ ./build.sh
```
