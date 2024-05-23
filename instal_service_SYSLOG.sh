#!/bin/bash
# Install rsyslog
sudo apt install -y rsyslog rsyslog-doc

# Edit rsyslog configuration file
sudo bash -c 'cat <<EOL > /etc/rsyslog.conf
#################
#### MODULES ####
#################

module(load="imuxsock") # provides support for local system logging
#module(load="immark")  # provides --MARK-- message capability

# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")

# provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" port="514")

# provides kernel logging support and enable non-kernel klog messages
module(load="imklog" permitnonkernelfacility="on")
EOL'

# Restart and check the status of rsyslog
sudo systemctl restart rsyslog.service
sudo systemctl status rsyslog

# Check if the syslog ports are open
netstat -na | grep :514
