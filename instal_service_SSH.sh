#!/bin/bash
# Check the status of the SSH service
sudo systemctl status ssh

# Start the SSH service
sudo systemctl start ssh

# Enable the SSH service to start on boot
sudo systemctl enable ssh
