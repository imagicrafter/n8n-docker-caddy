#!/bin/bash

# Step 2: Navigate to the project directory
cd n8n-docker-caddy

# Step 3: Install npm if not already installed
if ! command -v npm &> /dev/null
then
    echo "npm not found, installing npm..."
    sudo apt update
    sudo apt install -y npm
else
    echo "npm is already installed."
fi

# Step 4: Create Docker volumes
echo "Creating Docker volumes for caddy_data and n8n_data..."
sudo docker volume create caddy_data
sudo docker volume create n8n_data

# Step 5: Allow ports 80 and 443
echo "Allowing traffic on ports 80 and 443..."
sudo ufw allow 80
sudo ufw allow 443

nano caddy_config/Caddyfile
