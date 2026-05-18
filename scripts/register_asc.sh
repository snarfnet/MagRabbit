#!/bin/bash
set -e

# MagRabbit - App Store Connect 自動登録スクリプト
# Usage: ./scripts/register_asc.sh

echo "🚀 App Store Connect にアプリを登録"
echo "===================================="

# Configuration
APP_NAME="MagRabbit"
BUNDLE_ID="com.amasaki.MagRabbit"
API_KEY_ID="WDXGY9WX55"
API_ISSUER_ID="2be0734f-943a-4d61-9dc9-5d9045c46fec"
API_KEY_PATH="${HOME}/Downloads/AuthKey_${API_KEY_ID}.p8"
TEAM_ID="83VGKGSQUH"

# Verify API key
if [ ! -f "$API_KEY_PATH" ]; then
    echo "❌ API Key not found: $API_KEY_PATH"
    exit 1
fi

echo "✓ API Key verified"
echo

# Generate JWT token
echo "🔐 API認証中..."
CURRENT_DATE=$(date -u +%Y-%m-%d)
EXP=$(($(date +%s) + 20*60))

HEADER=$(echo -n '{"alg":"ES256","kid":"'${API_KEY_ID}'","typ":"JWT"}' | openssl base64)
PAYLOAD=$(echo -n '{"iss":"'${API_ISSUER_ID}'","iat":'$(date +%s)',"exp":'${EXP}',"aud":"appstoreconnect-v1"}' | openssl base64)

HEADER_PAYLOAD="${HEADER}.${PAYLOAD}"
SIGNATURE=$(echo -n "${HEADER_PAYLOAD}" | openssl dgst -sha256 -sign "$API_KEY_PATH" | openssl base64)

JWT="${HEADER_PAYLOAD}.${SIGNATURE}"

echo "✓ JWT生成完了"
echo

# Create app via API
echo "📝 アプリを登録中..."

RESPONSE=$(curl -s -X POST "https://api.appstoreconnect.apple.com/v1/apps" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "type": "apps",
      "attributes": {
        "name": "'${APP_NAME}'",
        "bundleId": "'${BUNDLE_ID}'",
        "primaryLocale": "ja-JP",
        "sku": "'${APP_NAME}'-001"
      },
      "relationships": {
        "appCategory": {
          "data": {
            "type": "appCategories",
            "id": "REFERENCE_APPS"
          }
        }
      }
    }
  }')

echo "$RESPONSE" | jq .

# Check response
if echo "$RESPONSE" | jq -e '.errors' > /dev/null 2>&1; then
    echo "❌ エラーが発生しました"
    exit 1
fi

APP_ID=$(echo "$RESPONSE" | jq -r '.data.id')
echo
echo "✅ アプリ登録完了!"
echo "App ID: $APP_ID"
echo
echo "📱 App Store Connect で確認:"
echo "https://appstoreconnect.apple.com/apps/${BUNDLE_ID}"
