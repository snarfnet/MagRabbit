# GitHub Actions - TestFlight 自動配信（3ステップ）

push → 自動ビルド → TestFlight にアップロード。簡潔版。

---

## ⚡ 3ステップ（10分）

### ステップ 1: GitHub リポジトリを作成＆初期化

```bash
# Windows で実行
cd /c/Users/Windows/MagRabbit

# Git 初期化
git init
git add .
git commit -m "Initial: Mag Rabbit 992 magazines"
git branch -M main

# GitHub にプッシュ
# (リポジトリ https://github.com/YOUR_USERNAME/MagRabbit 作成後)
git remote add origin https://github.com/YOUR_USERNAME/MagRabbit.git
git push -u origin main
```

### ステップ 2: GitHub Secrets を設定

GitHub.com にログイン → Settings → Secrets and variables → Actions

以下を追加：

| キー | 値 | 説明 |
|------|-----|------|
| `APPLE_ID` | your@email.com | Apple ID |
| `APPLE_PASSWORD` | パスワード | Apple ID パスワード |
| `APP_SPECIFIC_PASSWORD` | xxxxxx-xxxx-xxxx | アプリパスワード（[ここから生成](https://appleid.apple.com)） |

**アプリパスワード生成方法**:
```
https://appleid.apple.com
→ Security
→ App Passwords
→ "MagRabbit TestFlight"
→ 16文字パスワードをコピー
```

### ステップ 3: GitHub Actions が自動実行

```bash
# 何かコード変更して push
git add .
git commit -m "Update: something"
git push origin main

# ↓
# GitHub Actions が自動実行
# ↓
# 15-20分後 → TestFlight にアップロード完了
```

**進捗確認**:
```
GitHub → Actions → Build & Upload to TestFlight
→ 最新のワークフロー → ログ確認
```

---

## 🎉 完了！

これで自動化完成。

### 以降の使い方

```bash
# コード変更して push するだけ
git add .
git commit -m "Update: ..."
git push origin main

# 15-20分で TestFlight に自動アップロード ✅
```

### TestFlight で確認

```
App Store Connect
→ TestFlight
→ Build が更新されている ✅
```

---

## 🛠️ よくあるエラー

### ❌ "Code signing error"

**原因**: Apple ID パスワード間違い

**解決**:
```
GitHub → Settings → Secrets
APPLE_ID / APPLE_PASSWORD を確認
アプリパスワードを使用しているか確認
```

### ❌ "Could not verify Apple ID"

**原因**: 2要素認証

**解決**:
```
APPLE_PASSWORD ではなく APP_SPECIFIC_PASSWORD を使用
https://appleid.apple.com で "アプリパスワード" 生成
```

### ❌ GitHub Actions が実行されない

**原因**: Workflow ファイルがない

**解決**:
```
リポジトリに .github/workflows/testflight.yml が有るか確認
なければ手動でコミット＆プッシュ
```

---

## 📊 ワークフロー確認

GitHub → Actions タブ → Build & Upload to TestFlight

```
✅ Checkout code
✅ Setup Xcode
✅ Build Archive (5-8分)
✅ Export IPA
✅ Upload to TestFlight
✅ Success!
```

---

## 📈 今後の拡張

詳細は [GITHUB_ACTIONS_SETUP.md](./GITHUB_ACTIONS_SETUP.md) 参照

- Slack 通知
- 自動テスト実行
- リリースノート生成
- 複数ブランチ対応

---

**Done! 🐰 push するだけで TestFlight に自動配信。**

