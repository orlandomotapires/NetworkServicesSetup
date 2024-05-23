#!/bin/bash

# Update package list
sudo apt update

# Check if Apache2 is already installed, if not, install it
if ! dpkg -l | grep -q apache2; then
    sudo apt install -y apache2
    echo "Apache2 installed successfully."
else
    echo "Apache2 is already installed."
fi

# Start the Apache2 service
sudo systemctl start apache2

# Enable the Apache2 service to start on boot
sudo systemctl enable apache2

# Check the status of Apache2
sudo systemctl status apache2

# Instructions for updating the index.html file
echo "To update the web page content, edit the index.html file located at /var/www/html/index.html."
echo "Use the following command to edit the file: sudo nano /var/www/html/index.html"

# Show how to test accessing the site via the IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "To test your Apache2 server, open a web browser and navigate to http://$IP_ADDRESS"
