#!/usr/bin/env bash
set -euo pipefail

APP_ID="${APP_STORE_APP_ID:-6770562560}"
BASE_TERRITORY="${APP_STORE_BASE_TERRITORY:-USA}"
KEY_PATH="${RUNNER_TEMP:-/tmp}/AuthKey_${AUTHKEY_KEY_ID}.p8"
export APP_ID BASE_TERRITORY

echo "$AUTHKEY" | base64 -d > "$KEY_PATH"
chmod 600 "$KEY_PATH"

generate_jwt() {
  KEY_PATH="$KEY_PATH" AUTHKEY_KEY_ID="$AUTHKEY_KEY_ID" AUTHKEY_ISSUER_ID="$AUTHKEY_ISSUER_ID" ruby -ropenssl -rjson -rbase64 <<'RUBY'
def base64_url(value)
  Base64.urlsafe_encode64(value, padding: false)
end

def int_to_fixed_bytes(value)
  value.to_s(16).rjust(64, "0").scan(/../).map { |byte| byte.to_i(16) }.pack("C*")
end

now = Time.now.to_i
header = { alg: "ES256", kid: ENV.fetch("AUTHKEY_KEY_ID"), typ: "JWT" }
payload = { iss: ENV.fetch("AUTHKEY_ISSUER_ID"), iat: now, exp: now + 20 * 60, aud: "appstoreconnect-v1" }
token_body = [base64_url(JSON.generate(header)), base64_url(JSON.generate(payload))].join(".")
key = OpenSSL::PKey.read(File.read(ENV.fetch("KEY_PATH")))
der_signature = key.sign(OpenSSL::Digest::SHA256.new, token_body)
asn1_signature = OpenSSL::ASN1.decode(der_signature)
r = int_to_fixed_bytes(asn1_signature.value[0].value)
s = int_to_fixed_bytes(asn1_signature.value[1].value)
puts [token_body, base64_url(r + s)].join(".")
RUBY
}

JWT="$(generate_jwt)"
PRICE_POINTS_PATH="${RUNNER_TEMP:-/tmp}/app-price-points.json"
PRICE_SCHEDULE_PATH="${RUNNER_TEMP:-/tmp}/free-price-schedule.json"
PRICE_RESPONSE_PATH="${RUNNER_TEMP:-/tmp}/free-price-response.json"

curl -sS -X GET "https://api.appstoreconnect.apple.com/v1/apps/${APP_ID}/appPricePoints?filter%5Bterritory%5D=${BASE_TERRITORY}&limit=200&fields%5BappPricePoints%5D=customerPrice,territory" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -o "$PRICE_POINTS_PATH"

FREE_PRICE_POINT_ID="$(ruby -rjson -e '
  json = JSON.parse(File.read(ARGV[0]))
  if json["errors"]
    warn JSON.pretty_generate(json)
    exit 1
  end
  point = json.fetch("data", []).find { |item| item.dig("attributes", "customerPrice").to_f == 0.0 }
  unless point
    warn "Free price point was not found"
    warn JSON.pretty_generate(json.fetch("data", []).first(5))
    exit 1
  end
  puts point.fetch("id")
' "$PRICE_POINTS_PATH")"
export FREE_PRICE_POINT_ID

ruby -rjson -e '
  payload = {
    data: {
      type: "appPriceSchedules",
      attributes: {},
      relationships: {
        app: { data: { type: "apps", id: ENV.fetch("APP_ID") } },
        manualPrices: { data: [{ type: "appPrices", id: "${newprice-0}" }] },
        baseTerritory: { data: { type: "territories", id: ENV.fetch("BASE_TERRITORY") } }
      }
    },
    included: [
      {
        id: "${newprice-0}",
        type: "appPrices",
        attributes: { startDate: nil, endDate: nil },
        relationships: {
          appPricePoint: { data: { type: "appPricePoints", id: ENV.fetch("FREE_PRICE_POINT_ID") } }
        }
      }
    ]
  }
  File.write(ARGV[0], JSON.generate(payload))
' "$PRICE_SCHEDULE_PATH"

STATUS="$(curl -sS -X POST "https://api.appstoreconnect.apple.com/v1/appPriceSchedules" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -d @"$PRICE_SCHEDULE_PATH" \
  -o "$PRICE_RESPONSE_PATH" \
  -w "%{http_code}")"

if [ "$STATUS" != "201" ] && [ "$STATUS" != "409" ]; then
  cat "$PRICE_RESPONSE_PATH"
  exit 1
fi

echo "Free pricing is configured for App Store Connect app ${APP_ID}."
