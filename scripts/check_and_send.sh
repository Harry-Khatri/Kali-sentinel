#!/bin/bash

SCORE_FILE="./logs/threat_score.txt"
HTML_FILE="./logs/summary_latest.html"
TO="your_email@gmail.com"
SUBJECT="🛡️ Kali Sentinel Alert"

if [[ ! -f "$SCORE_FILE" ]]; then
  echo "[-] No threat score file found."
  exit 1
fi

SCORE=$(cut -d' ' -f1 "$SCORE_FILE")

if [[ "$SCORE" =~ ^[0-9]+$ ]] && (( SCORE > 60 )); then
  echo "[+] High threat detected! Sending alert email..."
  echo "Please find attached the threat summary report." | mutt -s "$SUBJECT [Score: $SCORE]" -a "$HTML_FILE" -- "$TO"
else
  echo "[✓] Threat score ($SCORE) is safe. No email sent."
fi

