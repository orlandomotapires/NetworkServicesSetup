#!/bin/bash

# Install the DHCP server
sudo apt install -y isc-dhcp-server

# Configure the DHCP server to use the correct interface
sudo bash -c 'echo "INTERFACESv4=\"enp0s8\"" > /etc/default/isc-dhcp-server'

# Backup the original DHCP configuration file
sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup

# Comment out the specified lines in the DHCP configuration file
sudo sed -i 's/^\(option domain-name "example.org";\)/#\1/' /etc/dhcp/dhcpd.conf
sudo sed -i 's/^\(option domain-name-servers ns1.example.org, ns2.example.org;\)/#\1/' /etc/dhcp/dhcpd.conf

# Insert the new DHCP configuration
sudo bash -c 'cat >> /etc/dhcp/dhcpd.conf << EOF
subnet 172.16.0.0 netmask 255.255.255.0 {
    range 172.16.0.20 172.16.0.50;
    option routers 172.16.0.10;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 172.16.0.10;
    option domain-name "eugostaumDHCP.com";
}
EOF'

# Restart and enable the DHCP server
sudo systemctl restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl status isc-dhcp-server
