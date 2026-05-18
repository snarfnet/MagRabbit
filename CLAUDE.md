# Mag Rabbit - Development Instructions

## スケーラビリティについて

### 現在の実装（20誌）
- JSON ローカル保存
- アプリバンドル内に magazines.json を含める
- すべてのデータをメモリにロード

### 300誌への拡張戦略

#### ✅ 可能な手段

**1. JSON ファイルサイズ拡張（推奨）**
- 300誌でもJSON ファイルサイズは～1-2MB
- アプリバンドルに含めて問題なし
- コード変更なし

**2. リモート JSON + キャッシング**
- Vercel / Firebase Hosting でホスト
- アプリ初回起動時にダウンロード
- UserDefaults + FileManager でキャッシュ
- アップデートボタンで再取得

**3. API + ページネーション**
- バックエンド（Node.js / Vercel）
- データベース（Firestore / Supabase）
- 初期: 20誌、スクロール時に追加取得
- 最小限のメモリ使用

**4. ハイブリッド（推奨）**
- 初回: 100誌をアプリにバンドル
- 追加: ユーザーが「さらに読み込む」ボタンで200+誌をリモート取得
- オフライン対応 + 最新情報も同期

---

## 実装のヒント

### 300誌の JSON 例

```json
[
  {
    "id": "fortean-times",
    "name": "Fortean Times",
    ...
  },
  // ... × 300
]
```

→ ファイルサイズ: 約 1.5-2MB

### メモリ効率化

現在のコード：
```swift
var magazines: [Magazine] = []
```

300誌でもメモリ影響は軽微（～5-10MB）

### パフォーマンス最適化

- グリッド表示: LazyVGrid で自動最適化
- スクロール: iOS が自動的にセル再利用
- フィルタリング: Dictionary<String, [Magazine]> でO(1)

---

## オプション: 拡張実装

### A. JSONRemote 版（小規模API不要）

```swift
// magazines-full.json を Vercel にホスト
// https://mag-rabbit.vercel.app/api/magazines.json

// ContentView に追加
@State private var isLoadingMore = false

func loadMoreMagazines() {
    // リモート JSON を fetch
    // UserDefaults にキャッシュ
}
```

### B. Firestore 版（完全スケーラブル）

```swift
import FirebaseFirestore

let db = Firestore.firestore()
db.collection("magazines")
    .limit(to: 20)
    .addSnapshotListener { snapshot, error in
        // リアルタイム更新
    }
```

---

## 推奨フロー

1. **現在**: 20誌版完成 → App Store 提出
2. **Phase 2**: 100誌にアップデート（JSON ファイル差し替え）
3. **Phase 3**: 300+誌 + リモート取得機能

---

## ローカライズ

現在: 日本語
追加時: 英語を descriptionJa と description で分離済み

```json
{
  "description": "English version",
  "descriptionJa": "日本語版"
}
```

→ Localizable.strings 追加すれば多言語対応可能

---

## AdMob 対応

- 20誌: バナー + インタースティシャル（3回に1回）
- 300誌: 同じ戦略で問題なし
- スクロール増加 → 広告インプレッション増加（収益向上）

---

## テスト方法

```bash
# ローカルビルド
xcodebuild build -scheme MagRabbit

# Simulator 実行
xcrun simctl openurl booted "magrabbit://detail/fortean-times"

# AdMob テスト
# Info.plist: GADApplicationIdentifier = "ca-app-pub-3940256099942544~1458002388" (テストID)
```

---

## 記憶メモ

- JSON ファイルは Data フォルダに保存
- AdMob SDKは SPM で管理
- 本番提出時は Humanizer 原則でASO最適化
- 新規アプリなので marketing URL は GitHub Pages または Vercel で設定
