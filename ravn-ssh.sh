#!/bin/bash
echo "checking for ifconfig & nmap"
if command -v ifconfig >/dev/null 2>&1; then
    if command -v nmap >/dev/null 2>&1; then
        echo -e "Great, ifconfig & nmap available"
    else
        echo -e "Nmap not installed, use the following command if ubuntu/debian:\n\tsudo apt-get install nmap"
        exit 1;
    fi
else
    echo -e "ifconfig & nmap not installed, use the following command if ubuntu/debian:\n\tsudo apt-get install ifconfig nmap"
    exit 1;
fi
echo -e "\nLooking for Ethernet IP"
# Get line with ip address using grep, cut the bcast and mask, using awk print just IP
ETH_IP="$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
echo -e "\nFound it! IP:$ETH_IP"
# Replace IP's last octate with .* using sed
ETH_IPGROUP="$(echo $ETH_IP | sed 's/\.[0-9]*$/.*/')"
echo -e "\nScanning for other Hosts on ETH0"
# Scan using nmap, exclude eth0 interface ip, get the 1st HOST, and save just IP
RAVN_IP="$(nmap -T5 $ETH_IPGROUP --exclude $ETH_IP | grep 'Nmap scan report for' | awk '{print $5}')"
echo -e "\nFound One! HOST:$RAVN_IP"
# Ask for Username
echo -e "\nEnter the Username for SSH: \c"
read RAVN_USERNAME
# SSH command
ssh $RAVN_USERNAME@$RAVN_IP
