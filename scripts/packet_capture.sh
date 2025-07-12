#!/bin/bash

# Config
INTERFACE="wlan0"  # Change this to wlan0 or your active adapter
DURATION=60       # Duration of capture in seconds
PCAP_DIR="./pcap"
DATE=$(date +"%Y-%m-%d_%H-%M")
PCAP_FILE="$PCAP_DIR/capture_$DATE.pcapng"

echo "[*] Starting packet capture on $INTERFACE for $DURATION seconds..."
touch "$PCAP_FILE"
chmod 666 "$PCAP_FILE"
timeout "$DURATION" tshark -i "$INTERFACE" -w "$PCAP_FILE"

echo "[✓] Packet capture saved to: $PCAP_FILE"
