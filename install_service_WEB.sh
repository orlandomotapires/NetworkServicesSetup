#!/bin/bash
# Update package list
sudo apt update

# Install Apache2
sudo apt install -y apache2

# Check the status of Apache2
sudo systemctl status apache2
