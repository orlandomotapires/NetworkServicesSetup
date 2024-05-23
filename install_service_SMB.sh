#!/bin/bash
# Install Samba
sudo apt update
sudo apt install -y samba

# Edit the Samba configuration file
sudo bash -c 'cat <<EOL > /etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   server string = %h server (Samba, Ubuntu)
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes

[public]
   path = /srv/samba/public
   browsable = yes
   writable = yes
   guest ok = yes
   read only = no
EOL'

# Create shared directory and set permissions
sudo mkdir -p /srv/samba/public
sudo chown nobody:nogroup /srv/samba/public
sudo chmod 0775 /srv/samba/public

# Restart Samba services
sudo systemctl restart smbd
sudo systemctl restart nmbd
