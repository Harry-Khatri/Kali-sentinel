#!/bin/bash
echo "[+] Cron ran at $(date)" >> ./logs/cron_debug.log
cd /home/kali/Desktop/kali-sentinel
bash ./scripts/sentinel.sh
