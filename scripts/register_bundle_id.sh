#!/bin/bash
set -euo pipefail

BUNDLE_ID="${BUNDLE_ID:-com.magrabbit.MagRabbit}"
BUNDLE_NAME="${BUNDLE_NAME:-MagRabbit}"
BUNDLE_PLATFORM="${BUNDLE_PLATFORM:-IOS}"
export BUNDLE_ID BUNDLE_NAME BUNDLE_PLATFORM

: "${AUTHKEY_KEY_ID:?AUTHKEY_KEY_ID is required}"
: "${AUTHKEY_ISSUER_ID:?AUTHKEY_ISSUER_ID is required}"
: "${AUTHKEY:?AUTHKEY is required}"

KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_${AUTHKEY_KEY_ID}.p8"
export KEY_PATH AUTHKEY_KEY_ID AUTHKEY_ISSUER_ID

echo "Registering Bundle ID"
echo "Bundle ID: ${BUNDLE_ID}"
echo "Platform: ${BUNDLE_PLATFORM}"

mkdir -p "$(dirname "$KEY_PATH")"
echo "$AUTHKEY" | base64 -d > "$KEY_PATH"
chmod 600 "$KEY_PATH"

generate_jwt() {
  ruby -ropenssl -rjson -rbase64 <<'RUBY'
def base64_url(value)
  Base64.urlsafe_encode64(value, padding: false)
end

def int_to_fixed_bytes(value)
  value.to_s(16).rjust(64, "0").scan(/../).map { |byte| byte.to_i(16) }.pack("C*")
end

now = Time.now.to_i
header = {
  alg: "ES256",
  kid: ENV.fetch("AUTHKEY_KEY_ID"),
  typ: "JWT"
}
payload = {
  iss: ENV.fetch("AUTHKEY_ISSUER_ID"),
  iat: now,
  exp: now + 20 * 60,
  aud: "appstoreconnect-v1"
}

token_body = [
  base64_url(JSON.generate(header)),
  base64_url(JSON.generate(payload))
].join(".")

key = OpenSSL::PKey.read(File.read(ENV.fetch("KEY_PATH")))
der_signature = key.sign(OpenSSL::Digest::SHA256.new, token_body)
asn1_signature = OpenSSL::ASN1.decode(der_signature)
r = int_to_fixed_bytes(asn1_signature.value[0].value)
s = int_to_fixed_bytes(asn1_signature.value[1].value)

puts [token_body, base64_url(r + s)].join(".")
RUBY
}

json_value() {
  ruby -rjson -e 'value = JSON.parse(STDIN.read); ARGV[0].split(".").each { |key| value = value.is_a?(Array) ? value[key.to_i] : value[key]; break if value.nil? }; puts value if value' "$1"
}

JWT=$(generate_jwt)

list_bundle_ids() {
  curl -sS -X GET "https://api.appstoreconnect.apple.com/v1/bundleIds?filter%5Bidentifier%5D=${BUNDLE_ID}" \
    -H "Authorization: Bearer ${JWT}" \
    -H "Content-Type: application/json"
}

RESPONSE=$(list_bundle_ids)

if echo "$RESPONSE" | grep -q '"errors"'; then
  echo "$RESPONSE"
  exit 1
fi

EXISTING_ID=$(echo "$RESPONSE" | json_value "data.0.id" || true)

if [ -n "$EXISTING_ID" ]; then
  echo "Bundle ID already exists: ${EXISTING_ID}"
  {
    echo "bundle_id=${BUNDLE_ID}"
    echo "bundle_id_resource_id=${EXISTING_ID}"
  } >> "${GITHUB_OUTPUT:-/dev/null}"
  exit 0
fi

CREATE_BODY=$(ruby -rjson -e '
puts JSON.generate({
  data: {
    type: "bundleIds",
    attributes: {
      identifier: ENV.fetch("BUNDLE_ID"),
      name: ENV.fetch("BUNDLE_NAME"),
      platform: ENV.fetch("BUNDLE_PLATFORM")
    }
  }
})
')

RESPONSE=$(curl -sS -X POST "https://api.appstoreconnect.apple.com/v1/bundleIds" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -d "$CREATE_BODY")

if echo "$RESPONSE" | grep -q '"errors"'; then
  echo "$RESPONSE"
  exit 1
fi

CREATED_ID=$(echo "$RESPONSE" | json_value "data.id")

echo "Bundle ID created: ${CREATED_ID}"
{
  echo "bundle_id=${BUNDLE_ID}"
  echo "bundle_id_resource_id=${CREATED_ID}"
} >> "${GITHUB_OUTPUT:-/dev/null}"
