#!/bin/bash

set -e

echo "🚀 Starting WOWONYAWIT Coin Deployment to Sui Testnet..."

# 1. Switch to testnet
echo "📡 Switching to Sui Testnet..."
sui client switch --env testnet

# 2. Get faucet coins for gas
echo "💰 Requesting faucet coins..."
sui client faucet

# 3. Navigate to project
cd suiworkshop

# 4. Build project
echo "🔨 Building Move module..."
sui move build

# 5. Publish to testnet and capture full output
echo "📤 Publishing module to testnet..."
PUBLISH_OUTPUT=$(sui client publish --gas-budget 100000000)
echo "$PUBLISH_OUTPUT"

# Extract Package ID from transaction digest or published objects
PACKAGE_ID=$(echo "$PUBLISH_OUTPUT" | grep -i "package" | grep -oP '0x[a-f0-9]{64}' | head -1)

# If not found, try alternative parsing
if [ -z "$PACKAGE_ID" ]; then
    PACKAGE_ID=$(echo "$PUBLISH_OUTPUT" | grep -oP '0x[a-f0-9]+' | grep -v "0x0000" | head -1)
fi

echo ""
echo "✅ Package ID: $PACKAGE_ID"
echo ""

# Save package ID for reference
echo "$PACKAGE_ID" > package_id.txt

echo "🎉 Deployment completed!"
echo "📦 Package ID saved to: suiworkshop/package_id.txt"
echo ""
echo "📋 Next steps:"
echo "1. Copy Package ID: $PACKAGE_ID"
echo "2. Use it in your mint transaction"
