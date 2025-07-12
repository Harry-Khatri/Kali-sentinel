#!/bin/bash

LOG_DIR="./logs"
SAFE_HOSTS="./config/safe_hosts.txt"
SAFE_PORTS="./config/safe_ports.txt"

LATEST_DIFF=$(ls -t "$LOG_DIR"/diff_*.log 2>/dev/null | head -n1)

if [[ ! -f "$LATEST_DIFF" ]]; then
    echo "[-] No diff logs found."
    exit 1
fi

echo "[*] Analyzing: $LATEST_DIFF"

# Filter NEW hosts
NEW_HOSTS=$(grep "^> " "$LATEST_DIFF" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u | while read ip; do
  grep -qx "$ip" "$SAFE_HOSTS" || echo "$ip"
done)

REMOVED_HOSTS=$(grep "^< " "$LATEST_DIFF" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u)

# Filter NEW ports
NEW_PORTS=$(grep "^> " "$LATEST_DIFF" | grep "open" | while read line; do
  port=$(echo "$line" | awk -F'/' '{print $1}')
  grep -qx "$port" "$SAFE_PORTS" || echo "$line"
done)

REMOVED_PORTS=$(grep "^< " "$LATEST_DIFF" | grep "open")

echo "===== SUMMARY =====" | tee ./logs/summary_latest.txt

echo "🆕 New Hosts:" | tee -a ./logs/summary_latest.txt
echo "$NEW_HOSTS" | tee -a ./logs/summary_latest.txt
echo | tee -a ./logs/summary_latest.txt

echo "🚫 Removed Hosts:" | tee -a ./logs/summary_latest.txt
echo "$REMOVED_HOSTS" | tee -a ./logs/summary_latest.txt
echo | tee -a ./logs/summary_latest.txt

echo "🔐 New Open Ports:" | tee -a ./logs/summary_latest.txt
echo "$NEW_PORTS" | sed -E '
s/(22\/tcp.*open.*)/\1 ⚠ SSH [HIGH]/;
s/(23\/tcp.*open.*)/\1 🚨 Telnet [CRITICAL]/;
s/(3306\/tcp.*open.*)/\1 🔥 MySQL [HIGH]/;
s/(445\/tcp.*open.*)/\1 🛑 SMB [HIGH]/;
s/(3389\/tcp.*open.*)/\1 🔥 RDP [CRITICAL]/;
s/(8080\/tcp.*open.*)/\1 🌐 WebMgmt [MODERATE]/;
s/(80\/tcp.*open.*)/\1 🌐 HTTP/;
s/(443\/tcp.*open.*)/\1 🔒 HTTPS/;
' | tee -a ./logs/summary_latest.txt

echo | tee -a ./logs/summary_latest.txt
echo "🔒 Removed Ports:" | tee -a ./logs/summary_latest.txt
echo "$REMOVED_PORTS" | tee -a ./logs/summary_latest.txt
echo "====================" | tee -a ./logs/summary_latest.txt

