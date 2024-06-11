#!/bin/bash

# Install NVIDIA drivers
apt update
apt install -y nvidia-driver-535

# Install Ollama, download model and create run script for user
curl -fsSL https://ollama.com/install.sh | sh
systemctl start ollama
systemctl enable ollama
ollama pull phi3:14b-medium-4k-instruct-q6_K
echo "ollama run phi3:14b-medium-4k-instruct-q6_K" > /home/adminuser/run.sh
chmod +x /home/adminuser/run.sh
chown adminuser:adminuser /home/adminuser/run.sh

# Check if the flag file exists
if [ ! -f /var/run/reboot-flag ]; then
  # Create the flag file
  touch /var/run/reboot-flag
  # Reboot the system
  reboot
fi
