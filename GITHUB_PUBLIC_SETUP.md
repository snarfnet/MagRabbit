# GitHub Actions Public - TestFlight 自動配信

パブリックリポジトリで GitHub Actions を実行。macOS ランナー無料利用可。

---

## ⚡ 4ステップ（15分）

### ステップ 1: Public リポジトリを作成

GitHub.com:
```
New repository
  Name: MagRabbit
  Description: 992 Niche Magazines iOS App
  ☑️ Public
  ☑️ Add a README
  Create repository
```

### ステップ 2: Windows で初期化＆push

```bash
cd /c/Users/Windows/MagRabbit

# Git セットアップ
git init
git add .
git commit -m "Initial: Mag Rabbit 992 magazines"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/MagRabbit.git
git push -u origin main
```

### ステップ 3: GitHub Secrets を設定（5分）

GitHub リポジトリ → Settings → Secrets and variables → Actions

**追加する Secrets:**

| キー | 値 | 取得方法 |
|------|-----|---------|
| `APPLE_ID` | your@apple.com | Apple ID メール |
| `APPLE_PASSWORD` | password | Apple ID パスワード |
| `APP_SPECIFIC_PASSWORD` | xxxx-xxxx-xxxx-xxxx | https://appleid.apple.com → Security |

**⚠️ 重要: パブリックリポジトリでも Secrets は暗号化されます。安全です。**

### ステップ 4: Push して自動実行

```bash
# 何か変更を加える（例）
git add .
git commit -m "Update: version bump"
git push origin main

# → GitHub Actions が自動実行開始
# → 15-20分後 → TestFlight にアップロード完了
```

---

## 🎯 進捗確認

### リアルタイム確認

```
GitHub → Actions タブ → Build & Upload to TestFlight
→ 最新ワークフロー → Logs
```

**表示される内容:**
```
✅ Checkout code
✅ Setup Xcode
✅ Build Archive (8-10分)
✅ Export IPA
✅ Upload to TestFlight
✅ Success!
```

### TestFlight で確認

```
App Store Connect
→ TestFlight
→ Builds
→ 新しいビルドが表示 ✅
```

---

## 💡 Public リポジトリのメリット

| 項目 | 内容 |
|------|------|
| macOS ランナー | 無料（毎月 3000 分まで） |
| ビルド時間 | 15-20分 × 月 10回 = 150-200分（余裕） |
| Secrets 管理 | 暗号化＆非表示✅ |
| ログ表示 | パブリック（見られても OK のみを記録） |
| コード | 誰でも見られる（オープンソース化） |

---

## 🔐 セキュリティ

### ✅ 安全な理由

1. **Secrets は暗号化**
   - APPLE_ID / APPLE_PASSWORD は暗号化
   - GitHub Actions でのみ復号化
   - ログには表示されない

2. **Workflow ファイルは見える**
   - `.github/workflows/testflight.yml` は public
   - ただしコマンドに Secrets は埋め込まない

3. **推奨プラクティス**
   - Secrets に認証情報を保存 ✅
   - 本番パスワードを Workflow に書かない ✅
   - 定期的にアプリパスワードをリセット ✅

### ⚠️ 注意点

```
❌ しないこと:
  - パスワードをコミットする
  - ログに出力する
  - URL に埋め込む

✅ すること:
  - Secrets に保存する
  - environment variables で参照
  - 月 1 回アプリパスワード更新
```

---

## 📊 無料クォータ

GitHub Actions macOS ランナー（public リポジトリ）:

```
毎月 3,000 分 無料
  ↓
ビルド時間: 約 20分
  ↓
150 回ビルド可能
  ↓
月 10回程度なら余裕で OK ✅
```

---

## 🚀 実行フロー

### 初回

```
git init
↓
git add .
↓
git commit -m "Initial"
↓
git push origin main
↓
[GitHub Actions 自動実行開始]
↓
15-20分後
↓
TestFlight に自動アップロード ✅
```

### 以降

```
コード変更
↓
git add .
↓
git commit -m "Update: ..."
↓
git push origin main
↓
[自動実行]
↓
✅ 完了
```

### ビルドをスキップしたい場合

```bash
git commit -m "Update: docs [skip ci]"
git push origin main

# [skip ci] を含むと GitHub Actions が実行されない
```

---

## 🛠️ トラブルシューティング

### ❌ "Code signing error"

GitHub Actions → Logs で確認:

```
Error: The provided identity is not available.
```

**原因**: Apple ID / パスワード が間違っている

**解決**:
```
1. GitHub Secrets を確認
2. APPLE_ID: メールアドレス
3. APPLE_PASSWORD: 実際のパスワード OR アプリパスワード
4. APP_SPECIFIC_PASSWORD: アプリパスワード（https://appleid.apple.com）
```

### ❌ "Could not verify Apple ID"

**原因**: 2要素認証が有効だが、アプリパスワードを使っていない

**解決**:
```
APP_SPECIFIC_PASSWORD を GitHub Secrets に追加
https://appleid.apple.com → Security → App Passwords
"MagRabbit" などと名前をつけて生成
```

### ❌ GitHub Actions が実行されない

**原因**: Workflow ファイルがない、またはトリガー が正しくない

**解決**:
```
1. .github/workflows/testflight.yml が存在するか確認
2. main ブランチに push しているか確認
3. GitHub → Actions → ワークフロー一覧で確認
```

### ❌ TestFlight へアップロード失敗

```
Error: 401 Unauthorized
```

**原因**: App Store Connect API 認証失敗

**解決**:
```
1. App Store Connect 管理者権限があるか確認
2. アプリパスワードが有効か確認
3. Bundle ID が正しいか確認
   Project → MagRabbit → General → Bundle Identifier
```

---

## 📈 モニタリング

### Workflow ステータス確認

GitHub リポジトリ:
```
Actions タブ → Build & Upload to TestFlight
→ 各ワークフロー実行の詳細確認
```

### メール通知（オプション）

GitHub → Settings → Notifications
```
☑️ Workflows
  ☑️ Failed workflows
  ☑️ Completed workflows
```

### Slack 通知（オプション）

`.github/workflows/testflight.yml` に追加:

```yaml
- name: Notify Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'TestFlight Build: ${{ job.status }}'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

Slack Webhook を GitHub Secrets に追加。

---

## 💰 コスト

```
Public リポジトリ + macOS ランナー
  ↓
0円 / 月（無料） ✅

月 3,000 分 まで無料利用可
→ ビルド 15-20分 × 150 回可能
→ 月 10-15 回なら余裕
```

---

## 🎉 完成フロー

```
Windows で git push
  ↓
GitHub Actions が自動実行
  ↓
macOS で Xcode ビルド（GitHub サーバー）
  ↓
TestFlight に自動アップロード
  ↓
15-20分後
  ↓
iPhone で TestFlight から Install
  ↓
✅ テスト開始
```

---

## 📝 よくある質問

**Q: Public だと誰でも見られて安全ですか？**
A: Secrets は見えません。暗号化されます。コードは見えますが、認証情報は保護されます。

**Q: 月 10回以上ビルドしたら？**
A: 超過分は有料（$0.008/分）。ただし月 3,000分までなら無料。

**Q: ビルドログに パスワードが出ませんか？**
A: 出ません。Secrets は自動的にマスクされます。

**Q: 複数のブランチで実行したい？**
A: Workflow ファイルで設定可能（develop など）。

---

## 🚀 今すぐ実行！

### コマンド（Windows）

```bash
cd /c/Users/Windows/MagRabbit

# 初期化
git init
git add .
git commit -m "Initial: Mag Rabbit 992"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/MagRabbit.git
git push -u origin main

# GitHub で Secrets 設定（5分）
# → 完了！
```

### 確認

```
GitHub → Actions → Build & Upload to TestFlight
→ 自動実行開始 ✅
→ 15-20分待機
→ TestFlight へアップロード完了
```

---

**Done! 🐰 Public GitHub で自動ビルド＆TestFlight 配信開始！**

