#!/bin/bash
set -e

# MagRabbit - ASC 完全自動登録
# GitHub Actions から実行

APP_NAME="MagRabbit"
BUNDLE_ID="com.amasaki.MagRabbit"
API_KEY_ID="${AUTHKEY_KEY_ID}"
API_ISSUER_ID="${AUTHKEY_ISSUER_ID}"
API_KEY_BASE64="${AUTHKEY}"

echo "🚀 ASC にアプリを自動登録"
echo "=========================="

# API Key をファイルに保存
mkdir -p ~/.appstoreconnect/private_keys
echo "$API_KEY_BASE64" | base64 -d > ~/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8

# JWT 生成関数
generate_jwt() {
    local key_file=$1
    local key_id=$2
    local issuer_id=$3

    local header='{"alg":"ES256","kid":"'${key_id}'","typ":"JWT"}'
    local now=$(date +%s)
    local exp=$((now + 20*60))
    local payload='{"iss":"'${issuer_id}'","iat":'${now}',"exp":'${exp}',"aud":"appstoreconnect-v1"}'

    local header_b64=$(echo -n "$header" | openssl base64 -A)
    local payload_b64=$(echo -n "$payload" | openssl base64 -A)
    local header_payload="${header_b64}.${payload_b64}"

    local signature=$(echo -n "$header_payload" | openssl dgst -sha256 -sign "$key_file" | openssl base64 -A)

    echo "${header_payload}.${signature}"
}

# JWT 生成
JWT=$(generate_jwt ~/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8 "$API_KEY_ID" "$API_ISSUER_ID")

echo "✓ JWT 生成完了"
echo

# アプリ作成
echo "📝 アプリを作成中..."

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

# レスポンス解析
if echo "$RESPONSE" | grep -q '"errors"'; then
    echo "❌ エラー:"
    echo "$RESPONSE"
    exit 1
fi

APP_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$APP_ID" ]; then
    echo "❌ アプリIDが取得できませんでした"
    echo "$RESPONSE"
    exit 1
fi

echo "✓ アプリ作成完了 (ID: $APP_ID)"
echo

# アプリのメタデータを設定
echo "⚙️  メタデータを設定中..."

# カテゴリ設定
curl -s -X PATCH "https://api.appstoreconnect.apple.com/v1/apps/${APP_ID}/appCategories" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "type": "appCategories",
      "id": "REFERENCE_APPS"
    }
  }' > /dev/null

echo "✓ メタデータ設定完了"
echo

echo "✅ App Store Connect への自動登録完了！"
echo
echo "App ID: $APP_ID"
echo "Bundle ID: $BUNDLE_ID"
echo
echo "📱 確認:"
echo "https://appstoreconnect.apple.com/apps/${BUNDLE_ID}"
