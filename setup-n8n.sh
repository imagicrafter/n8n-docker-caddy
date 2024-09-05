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

# Step 4: Configure PostgreSQL
echo "Configuring PostgreSQL..."
sudo -i -u postgres psql -c "CREATE USER n8n_user WITH PASSWORD 'password';"
sudo -i -u postgres createdb n8n_db
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE n8n_db TO n8n_user;"
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/14/main/postgresql.conf
sudo sh -c "echo 'host    all             all             0.0.0.0/0            md5' >> /etc/postgresql/14/main/pg_hba.conf"
sudo systemctl restart postgresql

# Step 5: Create Docker volumes
echo "Creating Docker volumes for caddy_data and n8n_data..."
sudo docker volume create caddy_data
sudo docker volume create n8n_data

# Step 6: Allow ports 80 and 443
echo "Allowing traffic on ports 80 and 443..."
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 5432

nano caddy_config/Caddyfile

