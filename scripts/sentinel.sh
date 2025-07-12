#!/bin/bash


echo "[Kali Sentinel] Starting Threat Detection..."

# Run network scan
echo "[*] Running network scan module..."
bash ./scripts/net_scan.sh

# Run packet capture
echo "[*] Running packet capture module..."
bash ./scripts/packet_capture.sh

# Send email alert
bash ./scripts/send_email.sh

echo "[✓] Sentinel run complete. Check logs and pcap directories."

# Start dashboard if not running
if ! pgrep -f dashboard.py > /dev/null; then
  echo "[*] Launching web dashboard..."
  nohup sentinel-venv/bin/python3 ./scripts/dashboard.py > /dev/null 2>&1 &
fi

echo "[*] Generating summary alert..."
bash ./scripts/analyze_diff.sh

echo "[*] Generating html report..."
bash ./scripts/generate_html.sh

# Run score logic
echo "[*] Calculating threat score..."
bash ./scripts/score_threat.sh

# Then send alert based on that score
echo "[*] Evaluating email alert..."
bash ./scripts/check_and_send.sh

# Log threat score history
bash ./scripts/log_score_history.sh
