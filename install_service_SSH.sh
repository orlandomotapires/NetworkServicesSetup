#!/bin/bash

# Check if SSH is already installed, if not, install it
if ! dpkg -l | grep -q openssh-server; then
    sudo apt update
    sudo apt install -y openssh-server
else
    echo "SSH is already installed."
fi

# Start the SSH service
sudo systemctl start ssh

# Enable the SSH service to start on boot
sudo systemctl enable ssh

# Check the status of the SSH service
sudo systemctl status ssh
