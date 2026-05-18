# Mag Rabbit TestFlight - Quick Start（5ステップ）

992誌版を最速で TestFlight にアップするための 5ステップ。

---

## 📋 3分でわかる全体フロー

```
Windows (現在)
    ↓
Mac に MagRabbit フォルダを転送（USB/Dropbox）
    ↓
Xcode で プロジェクト作成 & Swift ファイル追加
    ↓
Xcode でビルド & Simulator テスト
    ↓
AdMob ID を取得 & 設定
    ↓
Archive & App Store Connect にアップロード
    ↓
TestFlight で配信 & テスター招待
    ↓
🎉 TestFlight で動作確認
```

---

## ⚡ ステップ 1: Mac へ転送（5分）

### 1.1 MagRabbit フォルダをコピー

**方法 A: USB ドライブ**
```
Windows: MagRabbit フォルダ → USB
Mac: USB から ~/Downloads/MagRabbit にコピー
```

**方法 B: Dropbox / iCloud Drive**
```
Windows: MagRabbit フォルダ → Dropbox/MagRabbit
Mac: Dropbox から ダウンロード
```

**方法 C: メール（小さい場合）**
```
7zip で圧縮 → メール送信 → Mac で展開
```

### 1.2 確認

Mac ターミナル:
```bash
ls -la ~/Downloads/MagRabbit/MagRabbit/Data/magazines.json
# 出力: -rw-r--r--  1 user  group  587K  ... magazines.json ✅
```

---

## ⚡ ステップ 2: Xcode でプロジェクト作成（10分）

### 2.1 新規プロジェクト

```
Xcode → File → New → Project
iOS → App → Product Name: MagRabbit
Bundle ID: com.yourcompany.magrabbit
```

### 2.2 Swift ファイルをコピー（ドラッグアンドドロップ）

Finder で MagRabbit/MagRabbit/Models/Magazine.swift を
Xcode の Models グループにドラッグ

→ 以下を繰り返し:
- Magazine.swift → Models
- MagazineCard.swift → Views
- MagazineDetailView.swift → Views
- BannerAdView.swift → AdMob
- ColorExtension.swift → Helpers
- MagRabbitApp.swift → ルート（置換）
- ContentView.swift → ルート（置換）

### 2.3 magazines.json を追加

```
File → Add Files to MagRabbit
~ /Downloads/MagRabbit/MagRabbit/Data/magazines.json
☑️ Copy items if needed
☑️ Add to targets: MagRabbit
```

### 2.4 Google Mobile Ads SDK を追加

```
File → Add Packages
https://github.com/google-mobile-sdk/google-mobile-ads-ios.git
Version: 10.0.0 <
Add to: MagRabbit
```

---

## ⚡ ステップ 3: Xcode でテスト（5分）

### 3.1 ビルド

```
Product → Build (⌘ + B)
```

または下記のエラーが出たら:

```
Build failed: "GoogleMobileAds not found"
→ File → Add Packages で再度 SDK 追加
```

### 3.2 実行

```
Product → Run (⌘ + R)
```

**期待される結果:**
```
✅ Simulator で Mag Rabbit が起動
✅ 992誌がグリッド表示
✅ スクロール可能
✅ カテゴリフィルター動作
```

---

## ⚡ ステップ 4: AdMob 設定（5分）

### 4.1 AdMob で広告 ID を取得

```
https://admob.google.com
→ アプリを追加
→ 「Mag Rabbit」 / iOS
→ Bundle ID: com.yourcompany.magrabbit
→ [Create] ボタン
```

**取得するもの:**

| ID | 例 | 用途 |
|----|-----|------|
| App ID | `ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyy` | Info.plist |
| Banner Ad Unit | `ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyy` | BannerAdView.swift |
| Interstitial Ad Unit | `ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzz` | BannerAdView.swift |

### 4.2 Xcode に設定

#### ファイル 1: Info.plist

```
Project → MagRabbit → Info
+ 新規行追加
キー: GADApplicationIdentifier
値: ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyy
```

#### ファイル 2: BannerAdView.swift

行 13:
```swift
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyyyyyy"  // バナー
```

行 87:
```swift
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzzzzzzzz"  // インタースティシャル
```

### 4.3 Simulator で再テスト

```
⌘ + R
```

---

## ⚡ ステップ 5: TestFlight にアップロード（10分）

### 5.1 Archive を作成

```
Product → Archive
```

数分待機... (Organizer ウィンドウが開く)

### 5.2 Distribute

```
Archive 選択 → Distribute App ボタン
```

| 画面 | 選択 |
|------|------|
| 1. Method | App Store Connect |
| 2. Signing | Automatically manage signing |
| 3. Review | デフォルト |
| 4. Summary | [Upload] |

### 5.3 App Store Connect で確認

```
https://appstoreconnect.apple.com
→ My Apps → Mag Rabbit
→ Builds → TestFlight

Status: Processing → Ready to Test (5-10分待機)
```

### 5.4 テスター招待

```
TestFlight → Internal Testing
+ テスター追加（自分のメアド）
[Send Invite]
```

メールが届く → リンククリック → TestFlight で Install

---

## ✅ チェックリスト（5項目）

- [ ] MagRabbit を Mac に転送
- [ ] Xcode でプロジェクト作成＆ビルド成功
- [ ] Simulator で グリッド表示・スクロール確認
- [ ] AdMob ID を取得＆設定
- [ ] TestFlight にアップロード＆メール受信

---

## 🆘 よくあるエラー（解決方法）

### ❌ Build Failed: "GoogleMobileAds not found"

```
解決: File → Add Packages
https://github.com/google-mobile-sdk/google-mobile-ads-ios.git
```

### ❌ JSON ロードエラー

```
解決: Project → Build Phases → Copy Bundle Resources
magazines.json が在るか確認
```

### ❌ Archive 失敗

```
解決: Product → Clean Build Folder (⌘ + Shift + K)
その後 Product → Archive
```

### ❌ Xcode: "Not Authorized"

```
解決: Xcode → Preferences → Accounts
再度 Apple ID ログイン
```

---

## 📊 所要時間

| ステップ | 時間 |
|---------|------|
| 1. 転送 | 5分 |
| 2. Xcode セットアップ | 10分 |
| 3. テスト | 5分 |
| 4. AdMob | 5分 |
| 5. TestFlight | 10分 |
| **合計** | **35分** ✅ |

### 待機時間

| 処理 | 時間 |
|------|------|
| Xcode ビルド | 2-5分 |
| Archive 作成 | 3-5分 |
| アップロード | 2-3分 |
| Processing | 5-10分 |
| **計** | **15-25分** |

**全体目安: 約 1時間で TestFlight リリース 🚀**

---

## 詳細ガイドへのリンク

それぞれのステップの詳細は：

- **Xcode セットアップ詳細**: [XCODE_SETUP.md](./XCODE_SETUP.md)
- **TestFlight 詳細**: [TESTFLIGHT_GUIDE.md](./TESTFLIGHT_GUIDE.md)
- **スケーリング情報**: [SCALING_1000.md](./SCALING_1000.md)
- **全般情報**: [README.md](./README.md)

---

## 🎉 次は？

TestFlight で動作確認後：

1. **バグ修正**（あれば）
2. **App Store 正式提出**（審査 24-48時間）
3. **リリース！** 🚀

---

**Good luck! 🐰**

