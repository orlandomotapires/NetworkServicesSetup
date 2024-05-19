# Comandos para Habilitar os Serviços

## Logins e Senhas 

### Server Ubuntu VM
- **username**: orlandomotausr
- **password**: 20022

### Ubuntu Interface Gráfica Client
- **username**: ubuntuteste
- **password**: 20022

## Configurar Segunda Placa de Rede

1. Com a VM DESLIGADA, vá em “machine”, “settings”, “network”, e adicione um adaptador de rede adicional.

2. Editar o arquivo de configuração de rede:

    ```bash
    sudo nano /etc/netplan/50-cloud-init.yaml
    ```

3. O arquivo deve ficar assim:

    ```yaml
    network:
        ethernets:
            enp0s3:
                dhcp4: true
            enp0s8:
                dhcp4: false
                addresses: [172.16.0.10/24]
        version: 2
    ```

4. Aplicar a configuração:

    ```bash
    sudo netplan apply
    ```

## Serviços de Rede

### SSH

1. Verificar o status do serviço SSH:

    ```bash
    sudo systemctl status ssh
    ```

2. Iniciar o serviço SSH:

    ```bash
    sudo systemctl start ssh
    ```

3. Habilitar o serviço SSH para iniciar automaticamente:

    ```bash
    sudo systemctl enable ssh
    ```

4. Configurar o NAT e o port forwarding:
    - Vá em “machine”, “settings”, “network”, escolha “NAT”, vá em “port forwarding” e crie uma linha:
        - SSH TCP _ 22 _ 22 (underline significa em branco)

5. Conectar via SSH pelo Windows:
    - No Windows, execute:

    ```bash
    ssh orlandomotausr@127.0.0.1
    ```

### DHCP

1. Instalar o servidor DHCP:

    ```bash
    sudo apt install isc-dhcp-server
    ```

2. Editar o arquivo de configuração:

    ```bash
    sudo nano /etc/default/isc-dhcp-server
    ```

    Insira:

    ```plaintext
    INTERFACESv4="enp0s8"
    ```

3. Editar a configuração do DHCP:

    ```bash
    sudo nano /etc/dhcp/dhcpd.conf
    ```

    Comente as linhas:

    ```plaintext
    # option domain-name "example.org";
    # option domain-name-servers ns1.example.org, ns2.example.org;
    ```

    Insira:

    ```plaintext
    subnet 172.16.0.0 netmask 255.255.255.0 {
        range 172.16.0.20 172.16.0.50;
        option routers 172.16.0.10;
        option subnet-mask 255.255.255.0;
        option domain-name-servers 172.16.0.10;
        option domain-name "eugostaumDHCP.com";
    }
    ```

4. Reiniciar o servidor DHCP:

    ```bash
    sudo systemctl restart isc-dhcp-server
    sudo systemctl enable isc-dhcp-server
    sudo systemctl status isc-dhcp-server
    ```

5. Testar o servidor DHCP:

    ```bash
    sudo tail -f /var/log/syslog
    sudo tail -f /var/lib/dhcp/dhcpd.leases
    ```

6. Conectar via interfaces no cliente para testar.

### DNS

1. Instalar o servidor DNS Bind9:

    ```bash
    sudo apt install bind9
    ```

2. Editar a configuração local do Bind9:

    ```bash
    sudo nano /etc/bind/named.conf.local
    ```

    Insira:

    ```plaintext
    zone "eugostaum.com" {
        type master;
        file "/etc/bind/zones/db.examples.com";
    };
    ```

3. Editar as opções de configuração do Bind9:

    ```bash
    sudo nano /etc/bind/named.conf.options
    ```

    Insira:

    ```plaintext
    options {
            directory "/var/cache/bind";

            recursion yes;

            allow-recursion {any;};

            forwarders {
                    8.8.8.8;
                    8.8.4.4;
            };

            auth-nxdomain no;

            dnssec-validation auto;

            listen-on { 172.16.0.10; };

            listen-on-v6 { any; };
    };
    ```

4. Criar e configurar o arquivo de zona:

    ```bash
    sudo mkdir /etc/bind/zones
    sudo touch /etc/bind/zones/db.examples.com
    sudo nano /etc/bind/zones/db.examples.com
    ```

    Insira:

    ```plaintext
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
    ```

5. Verificar a configuração do Bind9:

    ```bash
    sudo named-checkconf
    sudo named-checkzone eugostaum.com /etc/bind/zones/db.examples.com
    ```

6. Reiniciar e verificar o status do Bind9:

    ```bash
    sudo systemctl restart bind9
    sudo systemctl status bind9
    ```

7. Testar o DNS no cliente:
    - Conectar na internet, receber um IP via DHCP do servidor, entrar no terminal e pingar o IP do servidor:

    ```bash
    (Máquina servidor) sudo tcpdump -i enp0s8 icmp
    (Máquina cliente) ping eugostaum.com
    ```

### WEB

1. Instalar o Apache2:

    ```bash
    sudo apt update
    sudo apt install apache2
    ```

2. Verificar o status do Apache2:

    ```bash
    sudo systemctl status apache2
    ```

3. Testar no cliente:
    - Inserir o DNS no navegador e verificar se a página `index.html` do Apache abre no navegador.

### FTP

1. Instalar o servidor FTP ProFTPD:

    ```bash
    sudo apt install proftpd
    ```

2. Editar a configuração do ProFTPD:

    ```bash
    sudo nano /etc/proftpd/proftpd.conf
    ```

    Insira:

    ```plaintext
    ServerName "EugostaumServer"
    ServerType standalone

    DefaultRoot ~
    RequireValidShell off
    Port 21
    ```

3. Reiniciar e verificar o status do ProFTPD:

    ```bash
    sudo systemctl restart proftpd
    sudo systemctl status proftpd
    netstat -an | grep :21
    ```

4. Instalar o FileZilla no cliente, conectar pelo IP do servidor e mover os arquivos.

### NTP

1. Instalar o NTP:

    ```bash
    sudo apt install ntp
    ```

2. Editar a configuração do NTP:

    ```bash
    sudo nano /etc/ntpsec/ntp.conf
    ```

    Insira:

    ```plaintext
    # /etc/ntp.conf: configuração do servidor NTP

    # Servidores NTP públicos do pool NTP
    pool 0.ubuntu.pool.ntp.org iburst
    pool 1.ubuntu.pool.ntp.org iburst
    pool 2.ubuntu.pool.ntp.org iburst
    pool 3.ubuntu.pool.ntp.org iburst

    # Restrições de acesso
    restrict default kod nomodify notrap nopeer noquery
    restrict -6 default kod nomodify notrap nopeer noquery

    # Permitir acesso local
    restrict 127.0.0.1
    restrict ::1

    # Permitir acesso de uma sub-rede específica (substitua pela sua sub-rede)
    restrict 172.16.0.10 mask 255.255.255.0 nomodify notrap

    # Drift file
    driftfile /var/lib/ntp/ntp.drift

    # Servidor de log
    logfile /var/log/ntp.log

    # Configuração de estatísticas (opcional)
    statsdir /var/log/ntpstats/
    statistics loopstats peerstats clockstats
    filegen loopstats file loopstats type day enable
    filegen peerstats file peerstats type day enable
    filegen clockstats file clockstats type day enable
    ```

3. Reiniciar e habilitar o NTP:

    ```bash
    sudo systemctl restart ntp
    sudo systemctl enable ntp
    sudo systemctl status ntp
    ```

4. Verificar o status do NTP:

    ```bash
    ntpq -p
    ```
5. Configurar o cliente NTP:

    ```bash
    sudo apt install ntp
    sudo nano /etc/ntp.conf
    ```

    Insira:

    ```plaintext
    # /etc/ntp.conf: configuração do cliente NTP

    # Servidor NTP do servidor específico
    server 172.16.0.10 iburst

    # Restrições de acesso
    restrict default kod nomodify notrap nopeer noquery
    restrict -6 default kod nomodify notrap nopeer noquery

    # Permitir acesso local
    restrict 127.0.0.1
    restrict ::1

    # Drift file
    driftfile /var/lib/ntp/ntp.drift

    # Servidor de log
    logfile /var/log/ntp.log

    # Configuração de estatísticas (opcional)
    statsdir /var/log/ntpstats/
    statistics loopstats peerstats clockstats
    filegen loopstats file loopstats type day enable
    filegen peerstats file peerstats type day enable
    filegen clockstats file clockstats type day enable
    ```

6. Reiniciar e verificar o status do NTP no cliente:

    ```bash
    sudo systemctl restart ntp
    sudo systemctl enable ntp
    sudo systemctl status ntp
    ```

7. Verificar se o cliente está sincronizando com o servidor:

    ```bash
    ntpq -p
    ```

## SMB (Grupo Revelação)

1. Instalar o Samba:

    ```bash
    sudo apt update
    sudo apt install samba
    ```

2. Editar a configuração do Samba:

    ```bash
    sudo nano /etc/samba/smb.conf
    ```

    Insira:

    ```plaintext
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
    ```

3. Criar o diretório compartilhado e ajustar permissões:

    ```bash
    sudo mkdir -p /srv/samba/public
    sudo chown nobody:nogroup /srv/samba/public
    sudo chmod 0775 /srv/samba/public
    ```

4. Reiniciar os serviços do Samba:

    ```bash
    sudo systemctl restart smbd
    sudo systemctl restart nmbd
    ```

5. Testar o Samba no servidor:

    ```bash
    smbclient //server_ip/public -U guest -N
    ```

6. Acessar a pasta compartilhada pelo cliente Ubuntu:
    - Abrir o gerenciador de arquivos no cliente Ubuntu.
    - No campo de endereço, inserir: `smb://172.16.0.10/public`
    - Pressionar Enter para acessar a pasta pública compartilhada.

## SYSLOG

1. Instalar o rsyslog:

    ```bash
    sudo apt install rsyslog rsyslog-doc
    ```

2. Editar a configuração do rsyslog:

    ```bash
    sudo nano /etc/rsyslog.conf
    ```

    Modifique o bloco de modules:

    ```plaintext
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
    ```

3. Reiniciar e verificar o status do rsyslog:

    ```bash
    sudo systemctl restart rsyslog.service
    sudo systemctl status rsyslog
    netstat -na | grep :514
    ```

4. Testar o syslog:
    - No servidor, execute:

    ```bash
    logger "teste"
    ```

    - Inserir no final do arquivo `/etc/rsyslog.conf` do CLIENTE:

    ```plaintext
    *.* @172.16.0.10:514    	(udp)
    *.* @@172.16.0.10:514		(tcp)
    ```

    - Reiniciar o rsyslog no cliente:

    ```bash
    sudo systemctl restart rsyslog
    ```

    - Verificar no servidor se os logs estão sendo recebidos.

---

Agora você tem todas as configurações e comandos necessários para habilitar e testar os serviços mencionados no seu ambiente Ubuntu.
