# Network Services Overview

This document provides an overview of various network services, their purposes, and key characteristics. These services are crucial for managing and maintaining a network infrastructure.

## Authors: 

- [Gabriel Souza Dunkel](https://github.com/gabrielsdunkel)
- [Orlando Mota Pires](https://github.com/orlandomotapires)

## SSH (Secure Shell)

SSH is a protocol for securely accessing and managing network devices over an unsecured network. It encrypts all data transmitted, ensuring confidentiality and integrity.

- **Purpose**: Securely access remote devices and transfer files.
- **Key Characteristics**:
  - Encrypted communication.
  - Authentication mechanisms (passwords, public key).
  - Port forwarding and tunneling.
- **Source**: [SSH Essentials](https://www.ssh.com/ssh/protocol/)
- **Installation Script**: [install_service_SSH.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_SSH.sh)

## DHCP (Dynamic Host Configuration Protocol)

DHCP is used to assign IP addresses and network configuration parameters automatically to devices on a network.

- **Purpose**: Automatically provide IP addresses and network settings to clients.
- **Key Characteristics**:
  - Reduces manual configuration.
  - Centralized management of IP addresses.
  - Can provide additional information like default gateway and DNS servers.
- **Source**: [DHCP Overview](https://www.webopedia.com/definitions/dhcp/)
- **Installation Script**: [install_service_DHCP.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_DHCP.sh)

## DNS (Domain Name System)

DNS translates human-readable domain names (like www.example.com) into IP addresses (like 192.168.1.1).

- **Purpose**: Resolve domain names to IP addresses.
- **Key Characteristics**:
  - Hierarchical and decentralized.
  - Improves user experience by allowing the use of memorable domain names.
  - Caching for faster query resolution.
- **Source**: [How DNS Works](https://www.cloudflare.com/learning/dns/what-is-dns/)
- **Installation Script**: [install_service_DNS.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_DNS.sh)

## Web Server (Apache2)

A web server delivers web pages to clients over the HTTP or HTTPS protocols. Apache2 is one of the most widely used web servers.

- **Purpose**: Host and deliver web content.
- **Key Characteristics**:
  - Supports static and dynamic content.
  - Modular architecture.
  - Extensive configuration options and security features.
- **Source**: [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
- **Installation Script**: [install_service_Apache2.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_WEB.sh)

## FTP (File Transfer Protocol)

FTP is used to transfer files between a client and a server over a network. ProFTPD is a popular FTP server software.

- **Purpose**: Transfer files between systems.
- **Key Characteristics**:
  - Supports various authentication methods.
  - Can be configured for anonymous access.
  - Allows for directory and file permission management.
- **Source**: [FTP Explained](https://www.hostinger.com/tutorials/ftp)
- **Installation Script**: [install_service_FTP.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_FTP.sh)

## NTP (Network Time Protocol)

NTP synchronizes the clocks of computers to a reference time source, ensuring accurate timekeeping across a network.

- **Purpose**: Synchronize system clocks across a network.
- **Key Characteristics**:
  - High precision and accuracy.
  - Can synchronize to internet-based time servers.
  - Essential for time-sensitive applications.
- **Source**: [NTP Documentation](http://www.ntp.org/documentation.html)
- **Installation Script**: [install_service_NTP.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_NTP.sh)

## SMB (Server Message Block)

SMB is a protocol for sharing files, printers, and other resources within a network. Samba is the software that implements SMB/CIFS.

- **Purpose**: Share files and printers over a network.
- **Key Characteristics**:
  - Allows file and printer sharing between different operating systems.
  - Supports network browsing and access control.
  - Can be integrated with Windows network environments.
- **Source**: [Samba Documentation](https://www.samba.org/samba/docs/)
- **Installation Script**: [install_service_SMB.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_SMB.sh)

## Syslog

Syslog is a protocol for logging system messages and events. It enables centralized logging from different network devices.

- **Purpose**: Centralized logging of system and network events.
- **Key Characteristics**:
  - Standardized message format.
  - Supports both local and remote logging.
  - Can be used for monitoring and alerting.
- **Source**: [Syslog Protocol](https://tools.ietf.org/html/rfc5424)
- **Installation Script**: [install_service_Syslog.sh](https://github.com/orlandomotapires/NetworkServicesSetup/blob/main/install_service_SYSLOG.sh)

## Using VMs and Docker for Network Services

### Virtual Machines

Virtual machines (VMs) allow you to run multiple operating systems on a single physical machine. Each VM has its own virtual hardware, including CPU, memory, and storage, isolated from other VMs.

- **Purpose**: Run multiple isolated environments on a single hardware platform.
- **Key Characteristics**:
  - Isolation: Each VM operates independently.
  - Flexibility: Run different operating systems simultaneously.
  - Resource Management: Allocate and manage resources per VM.
- **Source**: [Virtualization Basics](https://www.vmware.com/topics/glossary/content/virtual-machine.html)

#### Setting Up VMs:

- Use virtualization software (e.g., VirtualBox, VMware) to create VMs for each network service.
- Configure network settings to ensure proper communication between VMs.

### Docker

Docker is a platform that uses containerization to run applications. Containers package an application and its dependencies, allowing it to run consistently across different environments.

- **Purpose**: Simplify deployment and scaling of applications.
- **Key Characteristics**:
  - Lightweight: Containers share the host OS kernel, making them more efficient than VMs.
  - Portability: Containers can run consistently across different environments.
  - Scalability: Easily scale applications by running multiple container instances.
- **Source**: [Docker Documentation](https://docs.docker.com/get-started/)
- **Docker Kick Start Repository**: [Docker Kick Start](https://github.com/orlandomotapires/docker_kick_start)
  
#### Using:

- Create Docker images for each network service with the necessary configurations.
- Use Docker Compose to define and manage multi-container applications.



By leveraging VMs and Docker, you can create flexible, scalable, and isolated environments for deploying and managing network services efficiently.
