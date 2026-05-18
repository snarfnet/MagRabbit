#!/bin/bash
set -e

# MagRabbit - Build & Upload to TestFlight Script
# Usage: ./scripts/build_and_upload.sh

echo "🚀 MagRabbit Build & Upload to TestFlight"
echo "=========================================="

# Configuration
PROJECT_NAME="MagRabbit"
BUNDLE_ID="com.amasaki.MagRabbit"
SCHEME="MagRabbit"
CONFIGURATION="Release"

# Paths
BUILD_DIR="./build"
ARCHIVE_PATH="${BUILD_DIR}/${PROJECT_NAME}.xcarchive"
EXPORT_PATH="${BUILD_DIR}/export"
IPA_FILE="${EXPORT_PATH}/${PROJECT_NAME}.ipa"

# API Key Configuration
read -p "Enter App Store Connect API Key ID: " API_KEY_ID
read -p "Enter App Store Connect API Issuer ID: " API_ISSUER_ID
read -sp "Enter App Store Connect API Key (p8 file path): " API_KEY_PATH
echo

# Verify API key file exists
if [ ! -f "$API_KEY_PATH" ]; then
    echo "❌ API Key file not found: $API_KEY_PATH"
    exit 1
fi

echo "✓ Configuration loaded"
echo

# Step 1: Generate Xcode project with xcodegen
echo "📋 Generating Xcode project..."
if ! command -v xcodegen &> /dev/null; then
    echo "Installing xcodegen..."
    brew install xcodegen
fi
xcodegen generate -s project.yml
echo "✓ Project generated"
echo

# Step 2: Build Archive
echo "🔨 Building archive..."
mkdir -p "$BUILD_DIR"
xcodebuild archive \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination generic/platform=iOS \
    -archivePath "$ARCHIVE_PATH" \
    -derivedDataPath "${BUILD_DIR}/DerivedData" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO
echo "✓ Archive built"
echo

# Step 3: Create IPA
echo "📦 Creating IPA..."
mkdir -p "${BUILD_DIR}/Payload"
APP_PATH="${ARCHIVE_PATH}/Products/Applications/${PROJECT_NAME}.app"
cp -r "$APP_PATH" "${BUILD_DIR}/Payload/"
cd "$BUILD_DIR" && zip -r "export/${PROJECT_NAME}.ipa" Payload && cd ..
rm -rf "${BUILD_DIR}/Payload"
echo "✓ IPA created: $IPA_FILE"
echo

# Step 4: Upload to TestFlight
echo "📤 Uploading to TestFlight..."

# Copy API key to standard location
API_KEY_FILENAME=$(basename "$API_KEY_PATH")
cp "$API_KEY_PATH" "${HOME}/.private_keys/${API_KEY_FILENAME}" 2>/dev/null || mkdir -p "${HOME}/.private_keys" && cp "$API_KEY_PATH" "${HOME}/.private_keys/${API_KEY_FILENAME}"

xcrun altool \
    --upload-app \
    --type ios \
    --file "$IPA_FILE" \
    --api-issuer "$API_ISSUER_ID" \
    --api-key "$API_KEY_FILENAME"

echo
echo "✅ Upload complete!"
echo
echo "TestFlight での確認:"
echo "https://appstoreconnect.apple.com/apps/${BUNDLE_ID}/testflight/ios"
