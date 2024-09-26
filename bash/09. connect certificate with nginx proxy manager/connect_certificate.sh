#!/bin/bash

ID=2
DOMAIN="ennovify.com"
NGINX_PROXY_MANAGER_DIRECTORY="/home/rootless_podman/database/nginx_proxymanager"
NON_PREVILIDGED_USER="rootless_podman"

echo ID: $ID DOMAIN: $DOMAIN

# create necessary directory if it doesn't exist
sudo mkdir -p $NGINX_PROXY_MANAGER_DIRECTORY/custom_ssl/npm-$ID/

# copy the files
sudo cp /etc/letsencrypt/live/$DOMAIN-0001/privkey.pem $NGINX_PROXY_MANAGER_DIRECTORY/custom_ssl/npm-$ID/privkey.pem
sudo cp /etc/letsencrypt/live/$DOMAIN-0001/fullchain.pem $NGINX_PROXY_MANAGER_DIRECTORY/custom_ssl/npm-$ID/fullchain.pem

# Change permission
ls -l /home/rootless_podman/database/nginx_proxymanager/custom_ssl/npm-$ID
sudo chown $NON_PREVILIDGED_USER $NGINX_PROXY_MANAGER_DIRECTORY/custom_ssl/npm-$ID
sudo chown $NON_PREVILIDGED_USER $NGINX_PROXY_MANAGER_DIRECTORY/custom_ssl/npm-$ID/fullchain.pem
sudo chown $NON_PREVILIDGED_USER $NGINX_PROXY_MANAGER_DIRECTORY/custom_ssl/npm-$ID/privkey.pem

# Insert field into the table
sudo sqlite3 $NGINX_PROXY_MANAGER_DIRECTORY/database.sqlite "select id, created_on, nice_name, domain_names, expires_on from "main"."certificate" where id=$ID;"
sudo sqlite3 $NGINX_PROXY_MANAGER_DIRECTORY/database.sqlite "delete from "main"."certificate" where id=$ID;"
sudo sqlite3 $NGINX_PROXY_MANAGER_DIRECTORY/database.sqlite "select id, created_on, nice_name, domain_names, expires_on from "main"."certificate" where id=$ID;"
sudo sqlite3 $NGINX_PROXY_MANAGER_DIRECTORY/database.sqlite "INSERT INTO \"main\".\"certificate\"(\"id\", \"created_on\", \"modified_on\", \"owner_user_id\", \"is_deleted\", \"provider\", \"nice_name\", \"domain_names\", \"expires_on\", \"meta\") VALUES ($ID, '2022-11-19 18:49:22', '2022-11-19 18:49:22', 1, 0, 'other', 'Wild Card $(echo $DOMAIN)', '[\"*.$(echo $DOMAIN)\"]', '$(date -d "3 months" "+%Y-%m-%d %H:%M:%S")', '{ \"certificate\": \"$(sudo cat /etc/letsencrypt/live/$(echo $DOMAIN)/cert.pem )\", \"certificate_key\": \"$(sudo cat $(echo $NGINX_PROXY_MANAGER_DIRECTORY)/custom_ssl/npm-$(echo $ID)/privkey.pem)\"}');"
sudo sqlite3 $NGINX_PROXY_MANAGER_DIRECTORY/database.sqlite "select id, created_on, nice_name, domain_names, expires_on from "main"."certificate" where id=$ID;"

# # Change to the user
# sudo su $NON_PREVILIDGED_USER

# # # Restart the npm proxy manager
# podman stop nproxy
# podman start nproxy

# # Exiting from the user
# exit

# Run it using
# sudo bash connect_certificate.sh