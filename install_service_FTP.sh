#!/bin/bash
# Install ProFTPD FTP server
sudo apt install -y proftpd

# Edit the ProFTPD configuration file
sudo bash -c 'cat <<EOL > /etc/proftpd/proftpd.conf
ServerName "EugostaumServer"
ServerType standalone
DefaultRoot ~
RequireValidShell off
Port 21
EOL'

# Restart and check the status of ProFTPD
sudo systemctl restart proftpd
sudo systemctl status proftpd

# Check if the FTP port is open
netstat -an | grep :21
