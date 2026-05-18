#!/bin/bash
# このスクリプトは Mac 上で実行してください

set -e

echo "🚀 Fastlane セットアップ"
echo "======================="

# Fastlane インストール
echo "📦 Fastlane をインストール中..."
gem install fastlane

echo "✓ Fastlane インストール完了"
echo

# Fastlane 初期化
echo "⚙️  Fastlane を初期化中..."
cd "$(dirname "$0")/.."

fastlane init ios \
  --skip_credentials \
  --skip_source_control \
  --skip_cocoapods

echo "✓ Fastlane 初期化完了"
echo

echo "✅ セットアップ完了！"
echo
echo "次のコマンドを実行してください:"
echo "  ./scripts/register_app_fastlane.sh"
