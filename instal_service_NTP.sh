#!/bin/bash
# Install NTP server
sudo apt install -y ntp

# Edit the NTP configuration file
sudo bash -c 'cat <<EOL > /etc/ntpsec/ntp.conf
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst
restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
restrict 127.0.0.1
restrict ::1
restrict 172.16.0.10 mask 255.255.255.0 nomodify notrap
driftfile /var/lib/ntp/ntp.drift
logfile /var/log/ntp.log
statsdir /var/log/ntpstats/
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
EOL'

# Restart and enable the NTP service
sudo systemctl restart ntp
sudo systemctl enable ntp
sudo systemctl status ntp
