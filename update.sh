sudo docker compose pull
sudo docker compose down --rmi all --volumes --remove-orphans
sudo docker volume create caddy_data && sudo docker volume create n8n_data && sudo docker volume create npm_data
sudo docker compose up -d --force-recreate
sudo docker compose exec -u root n8n npm install -g axios moment uuid pg json-schema-generator openai @supabase/supabase-js
