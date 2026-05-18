# Xcode Project Setup Guide

Windows の MagRabbit フォルダを Mac に転送後、Xcode プロジェクトを作成するための完全ガイド。

## 📱 システム要件

- macOS 12.0 以上
- Xcode 14.0 以上
- 10GB 以上の空きストレージ

---

## ステップ 1: Mac に MagRabbit を転送

### 1.1 ファイルをコピー

**Windows から Mac へ**（Dropbox, iCloud Drive, USB 経由）

```bash
# Mac のターミナルで
cd ~/Downloads
ls -la MagRabbit/
```

確認項目:
- [ ] MagRabbit/MagRabbit/ フォルダがある
- [ ] MagRabbit/MagRabbit/Data/magazines.json がある（587KB）
- [ ] MagRabbit/MagRabbit/Models/Magazine.swift がある

---

## ステップ 2: Xcode プロジェクトを新規作成

### 2.1 Xcode を開く

```bash
open -a Xcode
```

### 2.2 新規プロジェクト

```
File → New → Project
```

### 2.3 テンプレート選択

```
iOS → App → Next
```

### 2.4 プロジェクト設定

| 項目 | 値 |
|------|-----|
| Product Name | `MagRabbit` |
| Organization Identifier | `com.yourcompany` |
| Bundle Identifier | `com.yourcompany.magrabbit` |
| Interface | `SwiftUI` |
| Language | `Swift` |
| Storage | `None` |

→ **Create**

### 2.5 保存場所

```
~/Documents/MagRabbit
```

（または任意の場所）

---

## ステップ 3: Swift Files をコピー

新規作成した Xcode プロジェクトに、Windows から転送した Swift ファイルをコピーします。

### 3.1 フォルダ構造を作成

Xcode 左パネル → Project Navigator で以下を右クリック

```
MagRabbit
├── Models (New Group)
├── Views (New Group)
├── AdMob (New Group)
├── Helpers (New Group)
└── Data (New Group)
```

**作成方法**: 右クリック → New Group → フォルダ名 入力

### 3.2 Swift ファイルを追加

各フォルダに対応する Swift ファイルをドラッグアンドドロップ：

```
Models/
└── Magazine.swift (Windows から コピー)

Views/
├── MagazineCard.swift
└── MagazineDetailView.swift

AdMob/
└── BannerAdView.swift

Helpers/
└── ColorExtension.swift
```

**ドラッグアンドドロップ方法**:
1. Finder で Swift ファイルを開く
2. Xcode の対応フォルダにドラッグ
3. 「Copy items if needed」をチェック
4. 「Add to targets: MagRabbit」をチェック
5. Create

### 3.3 主要ファイルを置換

既存ファイル（Xcode が自動作成）を置換:

```
MagRabbitApp.swift (置換)
ContentView.swift (置換)
```

**置換方法**:
1. 右クリック → Delete → Remove Reference
2. Windows 版をドラッグアンドドロップ

---

## ステップ 4: JSON Data を追加

### 4.1 Data フォルダを作成

Xcode → 右クリック → New Group → `Data`

### 4.2 magazines.json を追加

```
File → Add Files to "MagRabbit"...
```

→ `magazines.json`（Windows から転送版）を選択

確認:
- [ ] Copy items if needed: ☑️
- [ ] Add to targets: ☑️ MagRabbit

### 4.3 Build Phases で確認

Project → MagRabbit → Build Phases → Copy Bundle Resources

```
magazines.json が リストに있는지 确認
```

なければ「+」→「Add Files」→ magazines.json を追加

---

## ステップ 5: Package Dependencies を追加

### 5.1 Google Mobile Ads SDK を追加

```
File → Add Packages...
```

入力フィールドに:
```
https://github.com/google-mobile-sdk/google-mobile-ads-ios.git
```

→ Next

### 5.2 Version 設定

```
Up to Next Major Version
10.0.0 <
```

→ Add Package

### 5.3 Target を選択

```
Add to MagRabbit
```

→ Add Package

---

## ステップ 6: Project Settings を構成

### 6.1 Signing & Capabilities

```
Project → MagRabbit → Signing & Capabilities
```

| 項目 | 値 |
|------|-----|
| Automatically manage signing | ☑️ |
| Team | あなたの Apple Developer Team |

### 6.2 General タブ

```
Minimum Deployments: iOS 15.0
Supported Destinations: iPhone, iPad
```

### 6.3 Build Settings

Search: `Product Bundle Identifier`

```
com.yourcompany.magrabbit
```

---

## ステップ 7: Info.plist を設定

### 7.1 Info.plist を編集

```
Project → MagRabbit → Info
```

以下のキーを追加:

#### AdMob Configuration

```
GADApplicationIdentifier
Type: String
Value: ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyy
```

（AdMob から取得したアプリ ID を入力）

#### Network Configuration

```
NSLocalNetworkUsageDescription
Type: String
Value: Mag Rabbit uses local network to deliver ads efficiently.
```

```
NSBonjourServices
Type: Array
Value: _services._dns-sd._udp
```

### 7.2 App Transport Security

```
NSAppTransportSecurity
Type: Dictionary

NSAllowsArbitraryLoads: NO

NSExceptionDomains:
  googlemobileads.com:
    NSIncludesSubdomains: YES
    NSTemporaryExceptionAllowsInsecureHTTPLoads: NO
    NSTemporaryExceptionMinimumTLSVersion: TLSv1.2
```

---

## ステップ 8: Simulator でビルド & テスト

### 8.1 Scheme を選択

```
Product → Scheme → MagRabbit
```

### 8.2 Simulator を選択

```
Product → Destination → iPhone 15 (最新)
```

### 8.3 ビルド

```
Product → Build
```

または `⌘ + B`

### 8.4 実行

```
Product → Run
```

または `⌘ + R`

**期待される結果:**
- [ ] アプリが起動
- [ ] グリッドに 992誌が表示
- [ ] スクロール可能
- [ ] カテゴリフィルターが動作
- [ ] 雑誌をタップすると詳細ページ

---

## ステップ 9: AdMob Configuration（本番設定）

### 9.1 広告ユニット ID を取得

[Google AdMob](https://admob.google.com) で:

1. 「アプリを追加」
2. アプリ名: `Mag Rabbit`
3. プラットフォーム: iOS
4. Bundle ID: `com.yourcompany.magrabbit`
5. バナー広告ユニット ID: `ca-app-pub-...`
6. インタースティシャル広告ユニット ID: `ca-app-pub-...`

### 9.2 Xcode に設定

#### BannerAdView.swift

```swift
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyyyyyy"  // バナー
```

#### InterstitialAdManager (in BannerAdView.swift)

```swift
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzzzzzzzz"  // インタースティシャル
```

#### Info.plist

```
GADApplicationIdentifier: ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyy
```

---

## ステップ 10: Archive & TestFlight アップロード

### 10.1 Archive を作成

```
Product → Archive
```

### 10.2 Organizer が開く

```
Distribute App → App Store Connect
```

詳細は [TESTFLIGHT_GUIDE.md](./TESTFLIGHT_GUIDE.md) を参照

---

## 🛠️ トラブルシューティング

### ❌ Build Failed

**原因**: Google Mobile Ads SDK が見つからない

**解決**:
```
File → Add Packages
https://github.com/google-mobile-sdk/google-mobile-ads-ios.git
```

### ❌ Simulator がクラッシュ

**原因**: メモリ不足

**解決**:
```
Simulator を再起動
Xcode → Product → Clean Build Folder
```

### ❌ JSON ロードエラー

**原因**: magazines.json がバンドルに含まれていない

**解決**:
```
Project → Build Phases → Copy Bundle Resources
magazines.json が有るか確認
```

### ❌ AdMob 広告が表示されない

**原因**: テスト設定

**解決**:
```
Xcode Console で Test Device ID を確認
AdMob Dashboard → Settings → Test devices に追加
```

---

## ✅ チェックリスト

- [ ] MagRabbit フォルダが Mac に転送済み
- [ ] Xcode プロジェクト作成完了
- [ ] Swift ファイル 7個 追加完了
- [ ] magazines.json 追加＆バンドル確認
- [ ] Google Mobile Ads SDK 追加完了
- [ ] Info.plist 設定完了
- [ ] Simulator でビルド成功
- [ ] グリッド表示・スクロール確認
- [ ] AdMob ユニット ID 取得完了
- [ ] Xcode に AdMob ID 設定完了

---

## 🚀 次のステップ

すべてが正常に動作したら、[TESTFLIGHT_GUIDE.md](./TESTFLIGHT_GUIDE.md) に進んで TestFlight アップロードを開始してください。

---

**質問やエラーがあれば、console output（Xcode 下部パネル）を確認してください。**

