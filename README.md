# Mag Rabbit - 海外ニッチ雑誌紹介アプリ

世界のマニアックな雑誌を日本語で紹介するiOSアプリ。

## 概要

- **プラットフォーム**: iOS 15+
- **言語**: Swift, SwiftUI
- **収益**: AdMob（バナー + インタースティシャル）
- **データ**: JSON（ローカル保存）

## セットアップ手順

### 1. Xcodeでプロジェクトを開く

```bash
cd MagRabbit
open MagRabbit.xcodeproj
```

### 2. AdMob設定

#### 2.1 Google AdMob アカウント作成
- [Google AdMob](https://admob.google.com) にアクセス
- アカウント作成 / ログイン
- アプリを登録

#### 2.2 広告ユニットID取得
- バナー広告ユニットID
- インタースティシャル広告ユニットID

#### 2.3 コードに設定

`MagRabbit/AdMob/BannerAdView.swift` を編集：

```swift
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyyyyyy"  // バナー
let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzzzzzzzz"  // インタースティシャル
```

### 3. Info.plist設定

Xcode > Project > Info > Custom iOS Target Properties に以下を追加：

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyy</string>

<key>NSLocalNetworkUsageDescription</key>
<string>Mag Rabbitは広告配信のためにローカルネットワークにアクセスします</string>

<key>NSBonjourServices</key>
<array>
  <string>_services._dns-sd._udp</string>
</array>
```

### 4. GoogleMobileAds SDK をSPMで追加

Xcode > File > Add Packages...

```
https://github.com/google-mobile-sdk/google-mobile-ads-ios.git
```

- Version: 10.0.0以上
- Add to Project: MagRabbit

### 5. ビルド & テスト

```bash
xcodebuild build -scheme MagRabbit -destination 'platform=iOS Simulator,name=iPhone 15'
```

## プロジェクト構造

```
MagRabbit/
├── MagRabbitApp.swift          # アプリのエントリーポイント
├── ContentView.swift           # ホーム画面（グリッド表示）
├── Models/
│   └── Magazine.swift          # データモデル
├── Views/
│   ├── MagazineCard.swift      # グリッドカード
│   └── MagazineDetailView.swift # 詳細ページ
├── Data/
│   └── magazines.json          # 雑誌データ（20誌）
├── AdMob/
│   └── BannerAdView.swift      # バナー + インタースティシャル広告
├── Helpers/
│   └── ColorExtension.swift    # HEXカラー拡張
└── Info.plist
```

## 機能

### ✅ 実装済み
- 2列グリッド表示（20誌）
- カテゴリフィルター（横スクロール chips）
- 詳細ページ（日本語説明メイン）
- タグ表示
- 公式サイトへのリンク
- AdMob バナー広告
- AdMob インタースティシャル（3回に1回）

### 📊 雑誌データ（20誌）

| ジャンル | 雑誌数 |
|---------|--------|
| Weird | 1 |
| Animals | 4 |
| Food | 2 |
| DIY | 1 |
| Nature | 2 |
| Culture | 2 |
| Travel | 1 |
| Machines | 1 |
| Craft | 1 |
| Tech | 1 |
| Hobby | 1 |
| Plants | 1 |
| Literary | 1 |
| History | 1 |

## AdMobテスト設定

### テスト広告を表示する

開発中はGoogle提供のテストデバイスを使用：

```swift
let request = GADRequest()
request.keywords = ["test"]  // テスト広告表示
```

### テストデバイスIDの登録

Xcode のコンソールに出力される「Test Device ID」をAdMob ダッシュボードに登録。

## ビルド前チェックリスト

- [ ] AdMob広告ユニットID設定済み
- [ ] Info.plist に GADApplicationIdentifier 設定
- [ ] GoogleMobileAds SDK追加済み
- [ ] magazines.json がBundleに含まれている
- [ ] Bundle Identifier がAdMob登録済み

## リリース前

1. **テスト広告の削除**
   - BannerAdView.swift のテストキーワード削除

2. **本番広告ユニットIDに変更**
   - 実際のadUnitIDに置換

3. **App Store Connect設定**
   - カテゴリ: ニュース / エンターテインメント
   - 年齢区分: 4+
   - スクリーンショット準備

4. **テストビルド**
   - Simulator + Deviceでテスト
   - 広告表示確認
   - リンク遷移確認

## ライセンス

MIT

## 今後の拡張（オプション）

- [ ] 300+誌への拡張（API + pagination）
- [ ] お気に入り機能（UserDefaults）
- [ ] 検索機能
- [ ] ダークモード対応
- [ ] 多言語対応（英語）
- [ ] Share機能

---

**Made with 🐰 Mag Rabbit**
