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
