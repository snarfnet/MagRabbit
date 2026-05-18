#!/bin/bash
set -e

# MagRabbit - App Store Connect 自動登録スクリプト
# Usage: ./scripts/register_asc.sh

echo "🚀 App Store Connect にアプリを登録"
echo "===================================="

# Configuration
APP_NAME="MagRabbit"
BUNDLE_ID="com.magrabbit.MagRabbit"
API_KEY_ID="WDXGY9WX55"
API_ISSUER_ID="2be0734f-943a-4d61-9dc9-5d9045c46fec"
API_KEY_PATH="${HOME}/Downloads/AuthKey_${API_KEY_ID}.p8"
TEAM_ID="83VGKGSQUH"

# Verify API key
if [ ! -f "$API_KEY_PATH" ]; then
    echo "❁EAPI Key not found: $API_KEY_PATH"
    exit 1
fi

echo "✁EAPI Key verified"
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

echo "✁EJWT生�E完亁E
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

echo "$RESPONSE"

# Check response (simple grep instead of jq)
if echo "$RESPONSE" | grep -q '"errors"'; then
    echo "❁Eエラーが発生しました"
    exit 1
fi

if echo "$RESPONSE" | grep -q '"id"'; then
    APP_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
else
    echo "❁Eアプリ作�Eに失敗しました"
    exit 1
fi
echo
echo "✁Eアプリ登録完亁E"
echo "App ID: $APP_ID"
echo
echo "📱 App Store Connect で確誁E"
echo "https://appstoreconnect.apple.com/apps/${BUNDLE_ID}"
