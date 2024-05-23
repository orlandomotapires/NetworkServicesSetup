#!/bin/bash
# Install the DHCP server
sudo apt install -y isc-dhcp-server

# Configure the DHCP server to use the correct interface
sudo bash -c 'echo "INTERFACESv4=\"enp0s8\"" > /etc/default/isc-dhcp-server'

# Edit the DHCP configuration file
sudo nano /etc/dhcp/dhcpd.conf

# Restart and enable the DHCP server
sudo systemctl restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl status isc-dhcp-server
