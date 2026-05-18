# ローカルから TestFlight へアップロード

## 前提条件

- Xcode インストール済み
- App Store Connect にアプリ登録済み（Bundle ID: `com.amasaki.MagRabbit`）
- App Store Connect API Key（.p8 ファイル）を取得

## 手順

### 1. API Key の準備

App Store Connect で API Key を生成：

1. [App Store Connect](https://appstoreconnect.apple.com) にログイン
2. **Users and Access** → **Keys** → **App Store Connect API**
3. **+** をクリック、新しいキーを生成
4. Role: **Admin** を選択
5. **.p8 ファイルをダウンロード**（一度だけダウンロード可能）

API Key ID と Issuer ID もメモしておく

### 2. ビルド & アップロード実行

```bash
./scripts/build_and_upload.sh
```

プロンプトで以下を入力：
- API Key ID
- API Issuer ID
- API Key のパス（ダウンロードした .p8 ファイル）

### 3. 確認

アップロード完了後、以下で確認：

```
https://appstoreconnect.apple.com/apps/com.amasaki.MagRabbit/testflight/ios
```

テスターを追加してテスト配信開始

## トラブルシューティング

### "xcodegen が見つかりません"
```bash
brew install xcodegen
```

### "API Key が見つかりません"
- .p8 ファイルの正確なパスを指定
- ファイルが読み取り可能か確認

### altool エラー
- API Key ID が正しいか確認
- .p8 ファイルが有効か確認（有効期限など）
