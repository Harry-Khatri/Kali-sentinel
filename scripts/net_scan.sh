#!/bin/bash

# Config
TARGET="192.168.1.0/24"
SCAN_DIR="./scan"
DATE=$(date +"%Y-%m-%d_%H-%M")
OUTPUT="$SCAN_DIR/scan_$DATE.txt"
LATEST="$SCAN_DIR/latest.txt"
DIFF_LOG="./logs/diff_$DATE.log"

# Run fast scan
echo "[*] Scanning subnet: $TARGET"
nmap -T4 -F -oN "$OUTPUT" "$TARGET"

# Compare to last scan
if [[ -f "$LATEST" ]]; then
    echo "[*] Comparing with last scan..."
    diff "$LATEST" "$OUTPUT" > "$DIFF_LOG"
    echo "[+] Diff saved to: $DIFF_LOG"
else
    echo "[*] No previous scan to compare."
fi

# Update latest scan
cp "$OUTPUT" "$LATEST"
