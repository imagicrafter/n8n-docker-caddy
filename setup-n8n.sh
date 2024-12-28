#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt update

# Step 1: Install npm if not already installed
if ! command -v npm &> /dev/null
then
    echo "npm not found, installing npm..."
    sudo apt install -y npm
else
    echo "npm is already installed."
fi

# Step 2: Prompt for PostgreSQL Password
read -sp "Enter a custom password for the PostgreSQL user 'n8n_user': " pg_password
echo  # Move to a new line after input

# Step 3: Install PostgreSQL if not already installed
if ! command -v psql &> /dev/null
then
    echo "PostgreSQL not found, installing PostgreSQL..."
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
else
    echo "PostgreSQL is already installed."
fi

# Step 4: Configure PostgreSQL with the custom password
echo "Configuring PostgreSQL..."
sudo -i -u postgres psql -c "CREATE USER n8n_user WITH PASSWORD '$pg_password';"
sudo -i -u postgres createdb n8n_db
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE n8n_db TO n8n_user;"

# Modify PostgreSQL configuration for remote connections
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/14/main/postgresql.conf
sudo sh -c "echo 'host    all             all             0.0.0.0/0            md5' >> /etc/postgresql/14/main/pg_hba.conf"
sudo systemctl restart postgresql

# Step 5: Create Docker volumes
echo "Creating Docker volumes for caddy_data and n8n_data..."
sudo docker volume create caddy_data
sudo docker volume create n8n_data
sudo docker volume create npm_data

# Step 6: Allow ports 80, 443, and 5432 for PostgreSQL
echo "Allowing traffic on ports 80, 443, and 5432..."
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 5432

# Step 7: Prompt to Open and Edit Caddyfile
echo "Please review and edit your Caddyfile configuration."
nano caddy_config/Caddyfile
