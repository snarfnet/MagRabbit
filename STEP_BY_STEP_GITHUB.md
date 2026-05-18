# Mag Rabbit - GitHub セットアップ完全ガイド（ステップバイステップ）

Windows から GitHub public リポジトリへの push ～ TestFlight 確認まで。

---

## 📋 ステップ 1: GitHub アカウント＆リポジトリ作成（5分）

### 1.1 GitHub にサインアップ（未登録の場合）

```
https://github.com/signup
Email: your-email@example.com
Password: your-password
Username: your-username
```

### 1.2 新規リポジトリを作成

GitHub.com にログイン → 右上の「+」 → **New repository**

```
Repository name: MagRabbit
Description: 992 Niche Magazines iOS App with AdMob
Visibility: ☑️ Public
☑️ Add a README file
☑️ Add .gitignore → Swift を選択
Create repository
```

**結果:**
```
https://github.com/YOUR_USERNAME/MagRabbit
```

### 1.3 Clone URL をコピー

リポジトリページ → 緑色の「Code」ボタン → HTTPS

```
https://github.com/YOUR_USERNAME/MagRabbit.git
```

（後で使用）

---

## 📋 ステップ 2: Windows で Git を設定（3分）

### 2.1 Git をインストール（未インストールの場合）

```bash
# Git がインストール済みか確認
git --version
# → git version 2.x.x が表示されれば OK

# なければ https://git-scm.com からダウンロード
```

### 2.2 Git 初期設定

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

### 2.3 認証設定（Personal Access Token）

GitHub に push するときの認証が必要です。

**Personal Access Token を生成:**

GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token

```
Note: MagRabbit
Expiration: 90 days
Scopes:
  ☑️ repo (all)
  ☑️ workflow
  ☑️ write:packages
Generate token
```

**生成されたトークンをコピー**（後で使用）

```
ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

⚠️ **重要**: このトークンは今後使えません。どこかに保存してください。

---

## 📋 ステップ 3: Windows で MagRabbit を Git 初期化（3分）

### 3.1 プロジェクトディレクトリに移動

```bash
cd /c/Users/Windows/MagRabbit
ls -la
# 出力:
# MagRabbit/
# README.md
# GITHUB_PUBLIC_SETUP.md
# などが表示される
```

### 3.2 Git を初期化

```bash
git init
```

出力:
```
Initialized empty Git repository in /c/Users/Windows/MagRabbit/.git/
```

### 3.3 すべてのファイルをステージング

```bash
git add .
```

確認:
```bash
git status
```

出力:
```
On branch master
Initial commit
Changes to be committed:
  new file: MagRabbit/MagRabbitApp.swift
  new file: MagRabbit/Data/magazines.json
  ...（全ファイル）
```

### 3.4 初回コミット

```bash
git commit -m "Initial commit: Mag Rabbit 992 magazines"
```

出力:
```
[master (root-commit) abc1234] Initial commit: Mag Rabbit 992 magazines
 50 files changed, 50000 insertions(+)
```

### 3.5 ブランチを main に変更

```bash
git branch -M main
```

---

## 📋 ステップ 4: GitHub にプッシュ（2分）

### 4.1 Remote リポジトリを登録

```bash
git remote add origin https://github.com/YOUR_USERNAME/MagRabbit.git
```

確認:
```bash
git remote -v
```

出力:
```
origin  https://github.com/YOUR_USERNAME/MagRabbit.git (fetch)
origin  https://github.com/YOUR_USERNAME/MagRabbit.git (push)
```

### 4.2 GitHub に push

```bash
git push -u origin main
```

初回は認証が求められます：

```
Username for 'https://github.com': YOUR_USERNAME
Password for 'https://YOUR_USERNAME@github.com': [Personal Access Token をペースト]
```

出力（成功）:
```
Enumerating objects: 50, done.
Counting objects: 100% (50/50), done.
...
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

### 4.3 GitHub で確認

ブラウザで:
```
https://github.com/YOUR_USERNAME/MagRabbit
```

✅ MagRabbit/ フォルダ、magazines.json などが表示される

---

## 📋 ステップ 5: GitHub Secrets を設定（5分）

GitHub Actions が Apple ID で認証するために、Secrets を設定します。

### 5.1 Apple Developer Account の認証情報を準備

**①APPLE_ID**
```
your-email@apple.com
```

**②APPLE_PASSWORD**
```
Apple ID のパスワード
```

**③APP_SPECIFIC_PASSWORD（重要）**

Apple ID に 2要素認証がある場合は、**アプリパスワード**が必須：

```
https://appleid.apple.com
→ Sign In
→ Security
→ App Passwords
→ "MagRabbit TestFlight" と入力
→ Generate
→ 16文字パスワードをコピー（例: xxxx-xxxx-xxxx-xxxx）
```

### 5.2 GitHub Secrets に追加

GitHub リポジトリページ:

```
Settings → Secrets and variables → Actions
```

右上の「New repository secret」をクリック

**Secret 1: APPLE_ID**
```
Name: APPLE_ID
Secret: your-email@apple.com
Add secret
```

**Secret 2: APPLE_PASSWORD**
```
Name: APPLE_PASSWORD
Secret: your-apple-password
Add secret
```

**Secret 3: APP_SPECIFIC_PASSWORD**
```
Name: APP_SPECIFIC_PASSWORD
Secret: xxxx-xxxx-xxxx-xxxx
Add secret
```

完了後:
```
Settings → Secrets and variables → Actions
に 3 つの Secret が表示される ✅
```

---

## 📋 ステップ 6: GitHub Actions ワークフロー確認（1分）

### 6.1 Workflow ファイル確認

リポジトリ → Actions タブ

```
Build & Upload to TestFlight
が表示されている ✅
```

クリックして詳細を確認:
```
Trigger: push to main
On: push
  branches:
    - main
```

---

## 📋 ステップ 7: テスト用の push（コード変更をトリガー）

### 7.1 簡単な変更を加える

Windows ターミナル:

```bash
# 例: README に 1 行追加
echo "## Test Push" >> README.md
```

### 7.2 コミット＆プッシュ

```bash
git add .
git commit -m "Test: trigger GitHub Actions"
git push origin main
```

出力:
```
[main abc5678] Test: trigger GitHub Actions
 1 file changed, 1 insertion(+)
Updating abc1234..abc5678
Fast-forward
 README.md | 1 +
```

### 7.3 GitHub Actions が自動実行開始

GitHub リポジトリ → Actions タブ

```
Build & Upload to TestFlight
→ 最新ワークフロー（test: trigger... というコミットメッセージ）
```

クリック → Logs 確認:

```
✅ Set up job
✅ Checkout code
✅ Setup Xcode
⏳ Build Archive (3-5分待機)
...
```

---

## 📋 ステップ 8: ビルド進捗確認（15-20分待機）

### 8.1 ログをリアルタイム確認

GitHub → Actions → Build & Upload to TestFlight → [最新ワークフロー]

各ステップのログ:

```
✅ Checkout code ........... 1分
✅ Setup Xcode ............ 2-3分
⏳ Build Archive ........... 8-10分（待機）
✅ Export IPA ............ 2-3分
⏳ Upload to TestFlight ... 1-2分（待機）
✅ Success!
```

### 8.2 エラーが出た場合

```
❌ Step 名 をクリック
→ エラーメッセージ確認
→ GITHUB_PUBLIC_SETUP.md のトラブルシューティング参照
```

---

## 📋 ステップ 9: TestFlight で確認（5分）

### 9.1 App Store Connect にアクセス

```
https://appstoreconnect.apple.com
```

ログイン（Apple ID）

### 9.2 アプリを選択

```
My Apps → Mag Rabbit
```

### 9.3 Build を確認

```
TestFlight → iOS builds
```

**新しいビルドが表示されている！** ✅

```
Build 1 | v1.0 | Status: Processing → Ready to Test（5-10分待機）
```

### 9.4 ステータス変更を待つ

```
Processing (10分)
     ↓
Ready to Test ✅
```

---

## 📋 ステップ 10: テスターを招待（3分）

### 10.1 Internal Testing にテスターを追加

```
TestFlight
→ Internal Testing
→ Testers and Groups
→ + をクリック
```

テスター情報:
```
First Name: Test
Last Name: User
Email: your-email@example.com
```

### 10.2 招待メールを送信

```
Testers にチェック
→ [Save] → [Send Invite]
```

メールが届く:
```
Subject: Mag Rabbit TestFlight へのテスト招待
From: App Store Connect
Body: [Accept Invite]
```

### 10.3 招待を受け入れる

メール内の「Accept Invite」をクリック
→ TestFlight アプリで招待を受け入れ

---

## 📋 ステップ 11: iPhone に TestFlight をインストール

### 11.1 TestFlight アプリをインストール

iPhone / iPad で:

```
App Store → 検索「TestFlight」
→ [Get] → Face ID で認証
→ [Install]
```

### 11.2 TestFlight でテスト版アプリをインストール

```
TestFlight を開く
→ Mag Rabbit が表示される
→ [Install]
```

**待機:** インストール中（1-2分）

```
[Delete] に変われば インストール完了 ✅
```

---

## 📋 ステップ 12: iPhone でテスト実行

### 12.1 アプリを起動

```
iPhone ホーム画面
→ Mag Rabbit をタップ
```

### 12.2 動作確認チェックリスト

```
✅ アプリが起動
✅ グリッド表示（992誌）
✅ スクロール（スムーズ）
✅ カテゴリフィルター
✅ 雑誌をタップ → 詳細ページ
✅ 日本語説明が表示
✅ 「公式サイトを見る」→ Safari で開く
✅ バナー広告が表示
✅ クラッシュなし
✅ メモリ安定
```

### 12.3 バグ報告（あれば）

TestFlight で:
```
Mag Rabbit → [Send Beta Feedback]
バグ内容を入力 → 送信
```

---

## 🎉 完成！

```
992誌データ
  ↓ ✅
Mag Rabbit iOS アプリ完成
  ↓ ✅
GitHub public リポジトリ
  ↓ ✅
GitHub Actions 自動ビルド
  ↓ ✅
TestFlight に自動アップロード
  ↓ ✅
iPhone で 動作確認
  ↓
🚀 App Store に提出（次のステップ）
```

---

## 📊 今後のフロー

### Windows で コード変更

```bash
cd /c/Users/Windows/MagRabbit
# ファイルを変更
git add .
git commit -m "Update: ..."
git push origin main
```

### GitHub Actions が自動実行

```
GitHub → Actions → [ワークフロー実行]
15-20分待機
```

### TestFlight に自動アップロード

```
App Store Connect → TestFlight
新しいビルドが表示 ✅
```

### iPhone で自動更新

```
TestFlight で自動更新通知
[Update] をタップ
```

---

## 💡 Tips

### ビルドをスキップしたい場合

```bash
git commit -m "Update: docs [skip ci]"
git push origin main
# [skip ci] があると GitHub Actions が実行されない
```

### 特定のブランチのみ実行

`.github/workflows/testflight.yml` を編集:

```yaml
on:
  push:
    branches:
      - main
      - release/*  # release ブランチも実行
```

### ビルド完了時に通知

Slack Webhook を追加（オプション）

---

## 🚨 トラブルシューティング

### ❌ GitHub Actions が実行されない

```
確認:
1. push が成功したか確認（ターミナルで確認）
2. .github/workflows/testflight.yml が存在するか
3. main ブランチに push しているか
4. GitHub Actions が有効化されているか（Actions タブで確認）
```

### ❌ Code signing error

```
GitHub Actions → Logs
→ 「Code signing error」 確認

原因: APPLE_ID / APPLE_PASSWORD が間違っている
解決:
1. GitHub Secrets を再確認
2. アプリパスワード（2要素認証）を使用しているか
```

### ❌ TestFlight にアップロードされない

```
Logs で「altool」エラーを確認
→ Bundle ID / App Store Connect 認証を確認
```

---

## 📞 ヘルプ

問題が発生した場合:

1. **GitHub Actions ログ確認**
   ```
   GitHub → Actions → [ワークフロー] → Logs
   ```

2. **ドキュメント参照**
   - GITHUB_PUBLIC_SETUP.md（トラブルシューティング）
   - GITHUB_ACTIONS_SETUP.md（詳細）

3. **Apple サポート**
   - App Store Connect: https://help.apple.com/app-store-connect

---

**🎉 Mag Rabbit が TestFlight で動作中！**

次のステップ: App Store 正式提出

