# Kali Sentinel

**Kali Sentinel** is a lightweight, script-based threat detection and response system using tools like Nmap and Wireshark.

## Features
✅ Active Host & Port Scanning – Automated Nmap scans detect open ports, services, and live hosts.

🧠 Packet Capture & Logging – Tshark continuously logs packet-level data for analysis and investigation.

📨 Real-time Email Alerts – Sends alerts based on customizable rules (e.g., presence of specific IPs, open ports, anomalies).

📊 Flask-based Dashboard – Simple web interface to view logs, scan results, and system status.

🕒 Cron Integration – Schedule periodic scans and logging tasks for full automation.

📁 Log Management – Stores packet captures and scan reports for forensic investigation.



## Usage
1. Make scripts executable:
    chmod +x scripts/*.sh

2. Run all modules at once:
    ./scripts/sentinel.sh

3. if you want to run the full script with dashboard then you have to type the command:
   python3 ./scripts/dashboard.py

   [Note: this dashboard is made under FLASK so when you are going to kill the process you have to write the command for it(sudo pkill -f dashboard) 

# Kali-sentinel

