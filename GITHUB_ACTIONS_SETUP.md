# GitHub Actions - Auto Build & TestFlight

GitHub リポジトリに push すると自動的に ビルド → TestFlight にアップロード。

## 📋 セットアップ手順

### ステップ 1: GitHub リポジトリを作成

```bash
# GitHub で新規リポジトリ作成
# https://github.com/new

# リポジトリ名: MagRabbit
# 説明: 992 Niche Magazines iOS App
# Public / Private: Public（推奨）
```

### ステップ 2: ローカルで Git を初期化

```bash
cd /c/Users/Windows/MagRabbit
git init
git add .
git commit -m "Initial commit: Mag Rabbit 992 magazines version"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/MagRabbit.git
git push -u origin main
```

### ステップ 3: Apple Developer Secrets を設定

GitHub リポジトリ → Settings → Secrets and variables → Actions

以下を追加：

#### 3.1 `APPLE_ID`

```
Apple Developer Account のメールアドレス
例: your@email.com
```

#### 3.2 `APPLE_PASSWORD`

```
Apple Developer Account のパスワード
⚠️ 2要素認証がある場合は、
アプリ用パスワードを使用
```

参照: https://support.apple.com/ja-jp/HT204397

#### 3.3 `APP_SPECIFIC_PASSWORD`

```
App Store Connect 用アプリパスワード
https://appleid.apple.com → Security → App Passwords

生成: MagRabbit App Store Connect
コピーしたパスワードを GitHub Secrets に追加
```

#### 3.4 `APPLE_TEAM_ID` (オプション)

```
Apple Developer Team ID
https://developer.apple.com/account → Membership
Team ID をコピー
```

#### 3.5 `SLACK_WEBHOOK` (オプション)

```
Slack 通知用（ビルド完了を通知）
後で設定可能
```

### ステップ 4: Provisioning Profile をセットアップ

GitHub Actions は自動署名を使用するため、以下を確認：

1. **Apple Developer Account にログイン**
   - https://developer.apple.com

2. **Certificates, Identifiers & Profiles**
   - Identifiers → App IDs → MagRabbit
   - Capabilities を確認

3. **Signing Certificates**
   - "Apple Distribution" 証明書が存在するか確認
   - なければ作成

### ステップ 5: Xcode で事前設定（Mac で一度だけ）

```bash
# Mac でこれを実行して署名設定を初期化
cd ~/Downloads/MagRabbit
xcodebuild -scheme MagRabbit \
  -configuration Release \
  -allowProvisioningUpdates
```

---

## 🚀 使用方法

### 自動ビルド（main ブランチに push）

```bash
# コード変更
git add .
git commit -m "Update: Add new magazines"
git push origin main

# → GitHub Actions が自動実行
# → ビルド → TestFlight にアップロード
```

### 手動ビルド

GitHub UI で:
```
Actions → Build & Upload to TestFlight
Run workflow → Branch: main → Run workflow
```

### ビルド進捗確認

```
GitHub → Actions → Build & Upload to TestFlight
ビルド中... → 完了
```

---

## 📊 ワークフロー詳細

### `.github/workflows/testflight.yml` の流れ

```
1. Checkout: コードをダウンロード
2. Setup Xcode: 最新 Xcode をインストール
3. Install dependencies: 必要なライブラリをインストール
4. Build Archive: Xcode でアーカイブ作成
5. Export IPA: IPA ファイルをエクスポート
6. Upload to TestFlight: altool で TestFlight にアップロード
7. Notify Slack: 完了を Slack に通知（オプション）
```

### 実行時間

```
平均: 15-20分

内訳:
- Setup: 2-3分
- Build: 8-10分
- Export: 2-3分
- Upload: 2-3分
```

---

## ⚙️ 設定のカスタマイズ

### トリガー条件を変更

`.github/workflows/testflight.yml` の `on:` セクションで:

```yaml
on:
  push:
    branches:
      - main
      - develop
      - release/*
  pull_request:
    branches:
      - main
```

### スケジュール実行（毎日夜）

```yaml
on:
  schedule:
    - cron: '0 22 * * *'  # UTC 22:00 = JST 7:00
```

### 特定のタグでリリース

```yaml
on:
  push:
    tags:
      - 'v*'
```

---

## 🔐 セキュリティのベストプラクティス

### ✅ すること

- [ ] Secrets に認証情報を保存
- [ ] リポジトリを Private にする（本番用）
- [ ] ブランチ保護を設定
- [ ] Workflow の実行ログを確認

### ❌ しないこと

- [ ] パスワードをコードに含める
- [ ] パスワードをコミットメッセージに含める
- [ ] 認証情報をコンソールに出力

---

## 🛠️ トラブルシューティング

### ❌ ビルド失敗: "Code signing error"

**原因**: Apple Developer 認証失敗

**解決**:
```
1. Secrets を確認
   - APPLE_ID が正しいか
   - APPLE_PASSWORD が正しいか
   - APP_SPECIFIC_PASSWORD が有効か
2. 2要素認証: アプリパスワード使用
3. Apple ID が App Store Connect にアクセス可能か確認
```

### ❌ TestFlight アップロード失敗

**原因**: 認証情報または Bundle ID ミスマッチ

**解決**:
```
1. Bundle ID が正しいか確認
   Xcode → Project → General → Bundle Identifier
2. App Store Connect でアプリが登録されているか確認
3. Provisioning Profile が有効か確認
```

### ❌ Xcode バージョンエラー

**原因**: Xcode が古い

**解決**:
```yaml
# workflows/testflight.yml で最新を使用
xcode-version: latest-stable
```

### ❌ GitHub Actions が実行されない

**原因**: Workflow ファイルがない、またはトリガーが正しくない

**解決**:
```
1. `.github/workflows/testflight.yml` が存在するか確認
2. main ブランチに push されているか確認
3. Actions タブで有効化されているか確認
```

---

## 📈 監視＆ログ

### ビルドログを確認

```
GitHub → Actions → Build & Upload to TestFlight
→ 該当ビルド → Logs
```

### よくあるログメッセージ

```
✅ Build Archive: succeeded
✅ Export IPA: succeeded
✅ Upload to TestFlight: succeeded
```

### メール通知

GitHub で以下を有効化:

```
Settings → Notifications
→ Workflows → Notifications
→ "Send notifications for:"
   ☑️ Failed workflows
   ☑️ Completed workflows
```

---

## 🔄 CI/CD パイプライン拡張

### 自動テスト を追加

```yaml
- name: Run Unit Tests
  run: |
    cd MagRabbit
    xcodebuild test -scheme MagRabbit
```

### コード品質チェック

```yaml
- name: SwiftLint
  run: brew install swiftlint && swiftlint
```

###自動リリースノート生成

```yaml
- name: Generate Release Notes
  run: |
    echo "## Changes" > RELEASE_NOTES.md
    git log --oneline main..HEAD >> RELEASE_NOTES.md
```

---

## 📅 推奨フロー

### 開発フロー

```
1. feature ブランチで開発
   git checkout -b feature/new-feature

2. コミット & push
   git commit -am "Add: new feature"
   git push origin feature/new-feature

3. Pull Request を作成
   GitHub → Compare & Pull Request

4. レビュー＆マージ
   main ブランチに merge

5. 自動ビルド開始 ✅
   GitHub Actions が自動実行
   → TestFlight にアップロード
```

### リリースフロー

```
1. リリースブランチ作成
   git checkout -b release/1.1

2. バージョン更新
   Info.plist: Version 1.0 → 1.1

3. tag を作成
   git tag v1.1
   git push origin v1.1

4. 自動ビルド & TestFlight
   GitHub Actions 実行
   → App Store に提出
```

---

## 💡 Tips

### 環境変数を使用

```yaml
env:
  SCHEME: MagRabbit
  CONFIGURATION: Release
  TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
```

### キャッシング（ビルド高速化）

```yaml
- name: Cache SPM dependencies
  uses: actions/cache@v3
  with:
    path: ~/Library/Developer/Xcode/DerivedData
    key: ${{ runner.os }}-xcode-${{ hashFiles('Package.resolved') }}
```

### Artifact を保存

```yaml
- name: Upload IPA to artifacts
  uses: actions/upload-artifact@v3
  with:
    name: MagRabbit.ipa
    path: MagRabbit/build/export/MagRabbit.ipa
```

---

## 🎉 完成！

これで、GitHub に push するだけで自動的に TestFlight にアップロードされます。

```
git push origin main → 自動ビルド → TestFlight ✅
```

---

## 📞 よくある質問

**Q: 何度も TestFlight にアップロードしても OK？**
A: はい。ビルド番号は自動インクリメントされます。

**Q: 複数のテスター用に異なるビルドを？**
A: 同じビルドですが、TestFlight で複数グループに分配可能。

**Q: 自動承認（Auto-Review）は？**
A: App Store Connect で有効化すれば可能。

---

**Happy CI/CD! 🚀**

