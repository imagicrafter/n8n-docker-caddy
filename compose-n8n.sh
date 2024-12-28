# Step 6: Start the n8n container
echo "Starting n8n container..."
sudo docker compose up -d --force-recreate

# Step 7: Install custom npm libraries inside the n8n container
echo "Installing external npm libraries inside the n8n container..."
sudo docker compose exec -u root n8n npm install -g axios moment uuid pg json-schema-generator openai @supabase/supabase-js telegram

echo "Installation of npm packages done."
echo "N8N setup is complete and ready for use."
