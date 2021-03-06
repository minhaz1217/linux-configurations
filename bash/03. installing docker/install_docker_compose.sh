sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# If docker compose doesn't exist error give
# sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Test it
docker-compose --version

# To uninstall
# sudo rm /usr/local/bin/docker-compose