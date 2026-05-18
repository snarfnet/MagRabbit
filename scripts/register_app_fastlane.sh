#!/bin/bash
# このスクリプトは Mac 上で実行してください

set -e

echo "🚀 Fastlane で ASC にアプリを登録"
echo "=================================="

# 設定
APP_NAME="MagRabbit"
BUNDLE_ID="com.amasaki.MagRabbit"
TEAM_ID="83VGKGSQUH"
API_KEY_ID="WDXGY9WX55"
API_ISSUER_ID="2be0734f-943a-4d61-9dc9-5d9045c46fec"
API_KEY_PATH="${HOME}/Downloads/AuthKey_${API_KEY_ID}.p8"

# API Key 確認
if [ ! -f "$API_KEY_PATH" ]; then
    echo "❌ API Key が見つかりません: $API_KEY_PATH"
    exit 1
fi

echo "✓ API Key 確認"
echo

# fastlane produce でアプリ登録
echo "📝 ASC にアプリを登録中..."

cd "$(dirname "$0")/.."

fastlane produce \
  --app_name "$APP_NAME" \
  --bundle_identifier "$BUNDLE_ID" \
  --team_id "$TEAM_ID" \
  --api_key_path "$API_KEY_PATH" \
  --language "Japanese" \
  --skip_itc

echo
echo "✅ アプリ登録完了！"
echo
echo "📱 App Store Connect で確認:"
echo "https://appstoreconnect.apple.com/apps/${BUNDLE_ID}"
echo
echo "次のステップ:"
echo "  ./scripts/build_and_upload.sh"
