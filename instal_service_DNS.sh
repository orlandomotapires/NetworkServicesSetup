#!/bin/bash
# Install Bind9 DNS server
sudo apt install -y bind9

# Edit the local Bind9 configuration
sudo bash -c 'cat <<EOL > /etc/bind/named.conf.local
zone "eugostaum.com" {
    type master;
    file "/etc/bind/zones/db.examples.com";
};
EOL'

# Edit Bind9 options configuration
sudo bash -c 'cat <<EOL > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-recursion { any; };
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
    auth-nxdomain no;
    dnssec-validation auto;
    listen-on { 172.16.0.10; };
    listen-on-v6 { any; };
};
EOL'

# Create and configure the zone file
sudo mkdir -p /etc/bind/zones
sudo bash -c 'cat <<EOL > /etc/bind/zones/db.examples.com
$TTL    604800
@       IN      SOA     ns1.eugostaum.com. admin.eugostaum.com. (
                      2024051801         ; Serial
                            604800         ; Refresh
                             86400         ; Retry
                           2419200         ; Expire
                            604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.eugostaum.com.
@       IN      A       172.16.0.10
ns1     IN      A       172.16.0.10
www     IN      A       172.16.0.10
EOL'

# Verify Bind9 configuration
sudo named-checkconf
sudo named-checkzone eugostaum.com /etc/bind/zones/db.examples.com

# Restart and check the status of Bind9
sudo systemctl restart bind9
sudo systemctl status bind9
