# TestFlight Upload Guide - Mag Rabbit

992 誌版を TestFlight に登録するための完全ガイド。

## 📋 前提条件

- [ ] Mac (M1/Intel)
- [ ] Xcode 14.0 以上
- [ ] Apple Developer Account (年間 $99)
- [ ] App Store Connect アカウント

---

## ステップ 1: Xcode プロジェクトセットアップ（Mac）

### 1.1 Xcode でプロジェクトを開く

```bash
# Windows から Mac に MagRabbit フォルダを転送後
cd ~/Downloads/MagRabbit
open MagRabbit.xcodeproj
```

### 1.2 Project Settings を構成

Xcode メニュー → Project > MagRabbit

#### General タブ

| 設定項目 | 値 |
|---------|-----|
| Bundle Identifier | `com.yourcompany.magrabbit` |
| Version | `1.0` |
| Build | `1` |
| Supported Destinations | iOS 15.0+ |
| Team | あなたの Apple Developer Team |

#### Signing & Capabilities タブ

- [x] Automatically manage signing
- Team: `あなたのチーム`
- Provisioning Profile: `自動`

### 1.3 Google Mobile Ads SDK を追加

File → Add Packages...

```
https://github.com/google-mobile-sdk/google-mobile-ads-ios.git
```

- Version: `10.0.0` 以上
- Add to Target: `MagRabbit`

---

## ステップ 2: AdMob 設定

### 2.1 Google AdMob で広告ユニット ID を取得

1. [Google AdMob](https://admob.google.com) にアクセス
2. 「アプリを追加」
3. アプリ名: `Mag Rabbit`
4. プラットフォーム: `iOS`
5. Bundle ID: `com.yourcompany.magrabbit`

### 2.2 広告ユニットを作成

#### バナー広告
- ユニット名: `MagRabbit Banner`
- フォーマット: `Adaptive banner`
- ユニット ID: `ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyyyyyy`

#### インタースティシャル広告
- ユニット名: `MagRabbit Interstitial`
- フォーマット: `Interstitial`
- ユニット ID: `ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzzzzzzzz`

### 2.3 アプリ ID（App Identifier）を取得

AdMob ダッシュボード → アプリ → アプリ設定

```
ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyy
```

### 2.4 Xcode に設定

`MagRabbit/AdMob/BannerAdView.swift` を編集：

```swift
// バナー広告ユニット ID
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyyyyyy"

// インタースティシャル広告ユニット ID
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzzzzzzzz"
```

`MagRabbit/Info.plist` を編集：

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyy</string>
```

---

## ステップ 3: App Store Connect で アプリを登録

### 3.1 ログイン

[App Store Connect](https://appstoreconnect.apple.com) にログイン

### 3.2 新規アプリを作成

「My Apps」→ 「+」 → 「New App」

| 項目 | 値 |
|------|-----|
| Platform | iOS |
| Name | `Mag Rabbit` |
| Primary Language | `Japanese` |
| Bundle ID | `com.yourcompany.magrabbit` |
| SKU | `magrabbit-001` |
| User Access | Full Access |

### 3.3 アプリ情報を入力

#### App Information

- **App Name**: `Mag Rabbit`
- **Subtitle**: `世界のニッチ雑誌を発見`
- **Primary Category**: `News`
- **Secondary Category**: `Entertainment`

#### Pricing and Availability

- **Price**: `Free`
- **Available in**: `World Wide`
- **Age Rating**: `4+`

#### App Privacy Policy

```
https://yoursite.com/privacy
```

（プライバシーポリシーがない場合は、簡単な説明を作成）

#### Demo Account Information

**テスト用アカウント**（AdMob テスト用）

```
Email: test@example.com
Password: TestPassword123
```

（任意、テストで不要な場合は スキップ）

---

## ステップ 4: ビルド & アーカイブ

### 4.1 Scheme を確認

Xcode → Product > Scheme → `MagRabbit` が選択されているか確認

### 4.2 Archive を作成

```
Xcode → Product → Archive
```

初回は数分かかります。完了後、Organizer ウィンドウが開きます。

### 4.3 Distribution Options を選択

Organizer → `MagRabbit` → Archive 選択

「Distribute App」をクリック

| ステップ | 選択内容 |
|---------|---------|
| 1. Distribution Method | `App Store Connect` |
| 2. Signing | `Automatically manage signing` |
| 3. Review Options | デフォルト |
| 4. Summary | 確認して「Upload」 |

### 4.4 アップロード開始

```
Uploading... (数分待機)
Completed Successfully
```

✅ 成功メッセージが表示されたら完了

---

## ステップ 5: App Store Connect で TestFlight を設定

### 5.1 Build を確認

App Store Connect → Builds → TestFlight → Your App Builds

```
Status: Processing → Ready to Test (5-10分待機)
```

### 5.2 TestFlight の Testers を追加

左メニュー → **TestFlight** → **Testers and Groups**

#### Internal Testing

- 「+」をクリック
- テスター名、メールアドレスを入力
- 自分のメアドを追加（テスト用）

#### External Testing（オプション）

- テスターグループを作成
- メールアドレスを追加
- 「Send Invite」

### 5.3 Test Information を入力

**What to Test**

```
992誌のニッチ雑誌データベースをテストします。
- グリッド表示が正常に機能しているか
- カテゴリフィルターが動作しているか
- 詳細ページの日本語説明が表示されているか
- AdMob広告が読み込まれているか
- 外部リンク（公式サイト）が開くか

ぜひテストして、意見やバグ報告をお願いします！
```

### 5.4 Build を TestFlight に追加

「Builds」タブ → Build 選択 → 「TestFlight」に追加

---

## ステップ 6: TestFlight テスターへ招待送信

### 6.1 Invite を送信

TestFlight → Internal Testing → 「+」 → Testers 選択

テスター（自分）を選択 → 「Add」

### 6.2 招待メールを確認

自分のメールボックスに下記が届きます：

```
Subject: Mag Rabbit テストへの招待
From: App Store Connect

📱 TestFlight から Mag Rabbit をテストしてください
→ [Accept Invite] をクリック
```

### 6.3 TestFlight アプリをインストール

iPhone または iPad で：

1. App Store → 検索「TestFlight」
2. TestFlight をインストール
3. メール内のリンク「Accept Invite」をタップ
4. Mag Rabbit が TestFlight アプリに表示される
5. 「Install」をタップ

---

## ステップ 7: iOS デバイスでテスト

### テストチェックリスト

- [ ] **アプリ起動**: Mag Rabbit が起動する
- [ ] **グリッド表示**: 992誌が 2列グリッドで表示される
- [ ] **ロード時間**: 初期ロードが 1秒以内（目安）
- [ ] **スクロール**: スムーズなスクロール（60fps）
- [ ] **カテゴリフィルター**: 各カテゴリが正常にフィルターされる
- [ ] **詳細ページ**: 雑誌をタップすると詳細が開く
- [ ] **日本語表示**: 日本語説明が正しく表示される
- [ ] **タグ表示**: タグがチップで表示される
- [ ] **リンク**: 「公式サイトを見る」をタップすると Safari で開く
- [ ] **広告表示**: バナー広告が表示される
- [ ] **メモリ**: アプリが クラッシュしない（メモリ足りる）
- [ ] **ダークモード**: ダークモード対応（自動適応）

### バグ報告方法

TestFlight アプリで：

1. Mag Rabbit → 「Send Beta Feedback」
2. バグ / 改善提案を入力
3. スクリーンショットを添付（オプション）
4. 送信

---

## トラブルシューティング

### ❌ AdMob 広告が表示されない

**原因**: テスト広告 ID または設定ミス

**解決**:
```swift
// テスト広告を明示的に設定
let request = GADRequest()
request.keywords = ["test"]  // テスト モード
```

または

```
Xcode → Console で "Test Device ID" を確認
AdMob ダッシュボード → Settings → Test devices
```

### ❌ TestFlight アップロードが失敗

```
Error: "Could not verify Apple ID"
```

**解決**:
- 2要素認証を確認
- Apple ID パスワードを再入力
- Xcode → Preferences → Accounts で再ログイン

### ❌ JSON ロードエラー

```
Warning: Could not load magazine data
```

**解決**:
```
Xcode → Build Phases → Copy Bundle Resources
→ magazines.json がリストにあるか確認
```

---

## 次のステップ

### TestFlight テスト後（1-2週間）

- [ ] バグ修正
- [ ] スクリーンショット準備（5枚）
- [ ] App Description 最終確認
- [ ] App Store に正式提出

### スクリーンショット準備

```
iPhone 15 Pro (6.7")
- グリッドビュー
- フィルタリング
- 詳細ページ
- 日本語説明
- 外部リンク
```

---

## 📞 サポート

問題が発生した場合：

1. **Xcode コンソール**: ビルドエラーを確認
2. **App Store Connect**: ビルドステータスを確認
3. **Apple Developer Forums**: 質問投稿
4. **Google Mobile Ads**: AdMob サポート

---

## 🎉 完成！

TestFlight で 992誌版が動作確認できたら、App Store 正式提出まで 1ステップです！

**estimated Timeline**:
- ビルド＆アーカイブ: 15分
- アップロード: 5分
- Processing: 5-10分
- TestFlight テスト: 1-2週間
- 審査提出: 審査 24-48時間

---

**Good luck! 🐰 Mag Rabbit**
