#!/bin/bash

EMAIL_TO="harmankhatri248@gmail.com"
SUBJECT="⚠ Kali Sentinel Threat Alert"
HTML_BODY="./logs/summary_latest.html"

if [[ ! -f "$HTML_BODY" ]]; then
  echo "[!] HTML report not found!"
  exit 1
fi

echo "[*] Sending email to $EMAIL_TO..."
mutt -e 'set content_type=text/html' -s "$SUBJECT" "$EMAIL_TO" < "$HTML_BODY"

