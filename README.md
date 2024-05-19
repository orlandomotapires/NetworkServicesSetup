# Configuração de Rede e Serviços

## Comandos para habilitar os serviços

### Logins e Senhas

**Server Ubuntu VM**
- username: `orlandomotausr`
- password: `20022`

**Windows VM**
- username: `win11`
- password: `20022`

**Ubuntu Interface Gráfica Teste**
- username: `ubuntuteste`
- password: `20022`

## Configurar Segunda Placa de Rede

Com a VM DESLIGADA, vá em “machine”, “settings”, “network” e adicione um adaptador de rede adicional.

### Configuração do Netplan

```sh
sudo nano /etc/netplan/50-cloud-init.yaml
```

O arquivo deve ficar assim:

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

Aplicar as configurações do Netplan:

```sh
sudo netplan apply
```

## SSH

Verificar status do SSH:

```sh
sudo systemctl status ssh
```

Iniciar e habilitar SSH:

```sh
sudo systemctl start ssh
sudo systemctl enable ssh
```

Configurar Port Forwarding:

1. Vá em “machine”, “settings”, “network”, escolha “NAT”.
2. Vá em “port forwarding” e crie uma linha: `SSH TCP _ 22 _ 22` (underline significa em branco).

Conectar via SSH pelo Windows:

```sh
ssh orlandomotausr@127.0.0.1
```

## DHCP

Editar o arquivo de configuração do DHCP:

```sh
sudo nano /etc/default/isc-dhcpd-server
```

Adicionar a configuração da sub-rede:

```conf
subnet 172.16.0.0 netmask 255.255.255.0 {
    range 172.16.0.20 172.16.0.50;
    option routers 172.16.0.10;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 172.16.0.10;
    option domain-name "ex.cimatec.com.br";
}
```

Habilitar e iniciar o serviço DHCP:

```sh
sudo systemctl enable isc-dhcp-server
sudo systemctl start isc-dhcp-server
sudo systemctl status isc-dhcp-server
```

## DNS

Instalar o Bind9:

```sh
sudo apt install bind9
```

Editar o arquivo de configuração local do Bind9:

```sh
sudo nano /etc/bind/named.conf.local
```

Adicionar a zona DNS:

```conf
zone "eugostaum.com" {
    type master;
    file "/etc/bind/zones/db.examples.com";
};
```

Editar as opções de configuração do Bind9:

```sh
sudo nano /etc/bind/named.conf.options
```

Adicionar as seguintes opções:

```conf
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
```

Criar diretório e arquivo da zona:

```sh
sudo mkdir /etc/bind/zones
sudo touch /etc/bind/zones/db.examples.com
sudo nano /etc/bind/zones/db.examples.com
```

Adicionar a configuração da zona:

```conf
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

Verificar a configuração do Bind9:

```sh
sudo named-checkconf
sudo named-checkzone eugostaum.com /etc/bind/zones/db.examples.com
```

Reiniciar o serviço Bind9:

```sh
sudo systemctl restart bind9
sudo systemctl status bind9
```

## Parte do Cliente

Para configurar o cliente:

1. Desconectar da internet.
2. Configurar um IP manual qualquer.
3. Definir o gateway padrão como `172.16.0.10`.

Editar o arquivo `/etc/resolv.conf`:

```sh
sudo nano /etc/resolv.conf
```

Adicionar o servidor de nomes:

```conf
nameserver 172.16.0.10
```

## Teste FINAL

No servidor, capturar pacotes ICMP:

```sh
sudo tcpdump -i enp0s8 icmp 
```

No cliente,

## WEB

Atualizar pacotes:

```sh
sudo apt update
```
