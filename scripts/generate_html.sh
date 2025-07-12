 #!/bin/bash

INPUT="./logs/summary_latest.txt"
OUTPUT="./logs/summary_latest.html"
DATE=$(date +'%Y-%m-%d %H:%M')
THREAT_LEVEL="SAFE"

if grep -q "\[CRITICAL\]" "$INPUT"; then
  THREAT_LEVEL="CRITICAL"
elif grep -q "\[HIGH\]" "$INPUT"; then
  THREAT_LEVEL="HIGH"
elif grep -q "\[MODERATE\]" "$INPUT"; then
  THREAT_LEVEL="MODERATE"
fi


{
echo "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Kali Sentinel Report</title>"
echo "<style>
body { font-family: monospace; background: #111; color: #eee; padding: 20px; }
h2 { color: #0ff; }
.critical { color: red; font-weight: bold; }
.high { color: orange; }
.moderate { color: yellow; }
.secure { color: #0f0; }
</style></head><body>"

echo "<h2>🛡 Kali Sentinel Threat Report - $DATE</h2>"

# 🔘 Threat Level Badge
echo "<div style='padding:10px; font-size:18px;'>"
echo "⚠️ <b>Current Threat Level:</b> <span style='color:"
case "$THREAT_LEVEL" in
  CRITICAL) echo "red'>🔥 $THREAT_LEVEL 🔥";;
  HIGH) echo "orange'>⚠️ $THREAT_LEVEL ⚠️";;
  MODERATE) echo "yellow'>⚠️ $THREAT_LEVEL ⚠️";;
  *) echo "lightgreen'>✅ $THREAT_LEVEL ✅";;
esac
echo "</span></div><hr>"

# Then continue with main content
echo "<pre>"


# Convert and color-code
sed -E \
-e 's/\[CRITICAL\]/<span class="critical">\0<\/span>/g' \
-e 's/\[HIGH\]/<span class="high">\0<\/span>/g' \
-e 's/\[MODERATE\]/<span class="moderate">\0<\/span>/g' \
-e 's/\[SECURE\]/<span class="secure">\0<\/span>/g' \
"$INPUT"

echo "</pre></body></html>"
} > "$OUTPUT"

echo "[+] HTML report saved to: $OUTPUT"
cp "$OUTPUT" "./logs/summary_$(date +'%Y-%m-%d_%H-%M').html"
