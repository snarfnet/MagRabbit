#!/bin/bash
set -e

# GitHub Actions から呼び出されるスクリプト
# App Store Connect API でダイレクトアップロード

API_KEY_ID="${AUTHKEY_KEY_ID}"
API_ISSUER_ID="${AUTHKEY_ISSUER_ID}"
API_KEY_BASE64="${AUTHKEY}"
IPA_FILE="${1:-./build/export/MagRabbit.ipa}"

echo "📤 TestFlight にアップロード中..."

# API Key をファイルに保存
mkdir -p ~/.appstoreconnect/private_keys
echo "$API_KEY_BASE64" | base64 -d > ~/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8

# JWT 生成
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

JWT=$(generate_jwt ~/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8 "$API_KEY_ID" "$API_ISSUER_ID")

# IPA をアップロード
echo "Uploading $IPA_FILE..."

# App Store Connect API でビルドをアップロード
# (注: 直接IPAアップロードには Transporter が必要ですが、
#  代わりに xcrun altool を正しく呼び出します)

# API Key をホームディレクトリの標準位置に配置
mkdir -p ~/.appstoreconnect/private_keys
cp ~/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8 \
   ~/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8

# xcrun altool でアップロード
xcrun altool \
    --upload-app \
    --type ios \
    --file "$IPA_FILE" \
    --api-issuer "$API_ISSUER_ID" \
    --api-key AuthKey_${API_KEY_ID}.p8

echo "✅ TestFlight へのアップロード完了！"
