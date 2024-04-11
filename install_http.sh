#!/bin/bash

# Update package lists
sudo apt-get update -y

# Install Apache HTTP server
sudo apt install apache2 -y

# Start Apache HTTP server
sudo systemctl start apache2

# Enable Apache HTTP server to start on boot
sudo systemctl enable apache2
