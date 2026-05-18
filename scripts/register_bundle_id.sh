#!/bin/bash
set -e

# Bundle ID を App Store Connect に自動登録
# GitHub Actions から呼び出されるスクリプト

BUNDLE_ID="com.magrabbit.MagRabbit"
API_KEY_ID="${AUTHKEY_KEY_ID}"
API_ISSUER_ID="${AUTHKEY_ISSUER_ID}"
API_KEY_BASE64="${AUTHKEY}"

echo "🚀 Bundle ID を App Store Connect に登録"
echo "===================================="

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

    local header_b64=$(echo -n "$header" | openssl base64)
    local payload_b64=$(echo -n "$payload" | openssl base64)
    local header_payload="${header_b64}.${payload_b64}"

    local signature=$(echo -n "$header_payload" | openssl dgst -sha256 -sign "$key_file" | openssl base64)

    echo "${header_payload}.${signature}"
}

# JWT 生成
JWT=$(generate_jwt ~/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8 "$API_KEY_ID" "$API_ISSUER_ID")

echo "✓ JWT 生成完了"
echo
echo "DEBUG: JWT = ${JWT:0:50}..."
echo

# Bundle ID が既に存在するか確認
echo "📝 Bundle ID 確認中..."

set +e
RESPONSE=$(curl -s -X GET "https://api.appstoreconnect.apple.com/v1/bundleIds?filter[identifier]=${BUNDLE_ID}" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json")
CURL_EXIT=$?
set -e

echo "DEBUG: curl exit code = $CURL_EXIT"
echo "DEBUG: GET response = $RESPONSE"

# 既存をチェック
if echo "$RESPONSE" | grep -q '"identifier":"'${BUNDLE_ID}'"'; then
    echo "✓ Bundle ID は既に登録済み"
    exit 0
fi

echo "✓ 新しい Bundle ID を作成中..."

# Bundle ID を作成
RESPONSE=$(curl -s -X POST "https://api.appstoreconnect.apple.com/v1/bundleIds" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "type": "bundleIds",
      "attributes": {
        "identifier": "'${BUNDLE_ID}'",
        "name": "MagRabbit"
      }
    }
  }')

echo "DEBUG: POST response: $RESPONSE"

# レスポンス解析
if echo "$RESPONSE" | grep -q '"errors"'; then
    echo "❌ エラー:"
    echo "$RESPONSE"
    exit 1
fi

BUNDLE_ID_RESULT=$(echo "$RESPONSE" | grep -o '"identifier":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$BUNDLE_ID_RESULT" ]; then
    echo "❌ Bundle ID が取得できませんでした"
    echo "$RESPONSE"
    exit 1
fi

echo "✓ Bundle ID 作成完了"
echo

echo "✅ Bundle ID 登録完了！"
echo
echo "Bundle ID: $BUNDLE_ID_RESULT"
echo
echo "📱 App Store Connect で確認:"
echo "https://appstoreconnect.apple.com"
