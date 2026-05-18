# MagRabbit - 完全セットアップガイド

## 🎯 全体フロー

### Mac 上で実行

```bash
# 1. Fastlane セットアップ（初回のみ）
./scripts/setup_fastlane.sh

# 2. App Store Connect にアプリ登録
./scripts/register_app_fastlane.sh

# 3. ビルド & TestFlight アップロード
./scripts/build_and_upload.sh
```

---

## 📋 詳細手順

### ステップ 1: Fastlane セットアップ（初回のみ）

```bash
./scripts/setup_fastlane.sh
```

実行内容：
- ✅ Ruby Gems で Fastlane インストール
- ✅ fastlane init で初期化
- ✅ Fastlane ディレクトリ生成

### ステップ 2: App Store Connect にアプリ登録

```bash
./scripts/register_app_fastlane.sh
```

実行内容：
- ✅ API Key で認証
- ✅ Bundle ID: `com.amasaki.MagRabbit` でアプリ作成
- ✅ メタデータ自動設定

確認：
```
https://appstoreconnect.apple.com/apps/com.amasaki.MagRabbit
```

### ステップ 3: ビルド & TestFlight アップロード

```bash
./scripts/build_and_upload.sh
```

実行内容：
- ✅ xcodegen でプロジェクト生成
- ✅ xcodebuild でビルド
- ✅ IPA 作成
- ✅ xcrun altool で TestFlight アップロード

プロンプト入力：
```
API Key ID: WDXGY9WX55
Issuer ID: 2be0734f-943a-4d61-9dc9-5d9045c46fec
API Key Path: ~/Downloads/AuthKey_WDXGY9WX55.p8
```

確認：
```
https://appstoreconnect.apple.com/apps/com.amasaki.MagRabbit/testflight/ios
```

---

## 📱 GitHub Actions 自動ビルド

別途、GitHub Actions で IPA を自動生成：
- リポジトリ: https://github.com/snarfnet/MagRabbit
- ワークフロー: `.github/workflows/testflight.yml`
- トリガー: main ブランチへ push

ビルド成績: Actions → 最新実行 → Artifacts で IPA ダウンロード可能

---

## 🔑 認証情報

```
Apple ID: tokyonasu@yahoo.co.jp
Team ID: 83VGKGSQUH
API Key ID: WDXGY9WX55
Issuer ID: 2be0734f-943a-4d61-9dc9-5d9045c46fec
Bundle ID: com.amasaki.MagRabbit
```

---

## ⚠️ トラブルシューティング

### "Permission denied" エラー
```bash
chmod +x ./scripts/*.sh
```

### "xcodegen not found"
```bash
brew install xcodegen
```

### "API Key が見つかりません"
- ファイルパスを確認: `~/Downloads/AuthKey_WDXGY9WX55.p8`
- または新しい API Key を App Store Connect で生成

### TestFlight アップロード失敗
- Bundle ID が正しいか確認
- API Key が有効期限内か確認
- ネットワーク接続を確認

---

## 📝 次のステップ

1. **テスター追加**
   - ASC → TestFlight → 内部テスター を追加
   - ビルドを受け入れれば iOS デバイスでテスト可能

2. **App Store 審査申請**
   - メタデータ（説明、スクリーンショット等）を完成
   - ASC → バージョン情報 で審査提出

3. **自動更新**
   - GitHub Actions で main ブランチへ push するたび自動ビルド
   - 必要に応じて TestFlight アップロードも自動化可能
