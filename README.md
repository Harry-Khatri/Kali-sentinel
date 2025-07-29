# Kali Sentinel

**Kali Sentinel** is a lightweight, script-based threat detection and response system using tools like Nmap and Wireshark.

## Features
- Subnet scanning with Nmap
- Differential analysis of network changes
- Packet capture with TShark
- Logging and alert-ready structure

## Usage
1. Make scripts executable:
    chmod +x scripts/*.sh

2. Run all modules at once:
    ./scripts/sentinel.sh

3. if you want to run the full script with dashboard then you have to type the command:
   python3 ./scripts/dashboard.py

   [Note: this dashboard is made under FLASK so when you are going to kill the process you have to write the command for it(sudo pkill -f dashboard) 

# Kali-sentinel

