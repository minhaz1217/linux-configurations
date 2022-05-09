sudo certbot certonly -d '*.minhazul.com' --manual
TXT Record >> _acme-challenge.minhazul.com >> value
nslookup -type=TXT _acme-challenge.minhazul.com

sudo ln -sf /etc/letsencrypt/live/minhazul.com/privkey.pem ~/database/nginx_proxymanager/custom_ssl/npm-1/privkey.pem
sudo ln -sf /etc/letsencrypt/live/minhazul.com/fullchain.pem ~/database/nginx_proxymanager/custom_ssl/npm-1/fullchain.pm

sudo cat /etc/letsencrypt/live/minhazul.com/privkey.pem
sudo cat /etc/letsencrypt/live/minhazul.com/cert.pem

echo { \"certificate\": \"$(sudo cat /etc/letsencrypt/live/minhazul.com/cert.pem )\", \"certificate_key\": \"$(sudo cat /etc/letsencrypt/live/minhazul.com/privkey.pem)\"} > nginx_meta
echo "INSERT INTO \"main\".\"certificate\"(\"id\", \"created_on\", \"modified_on\", \"owner_user_id\", \"is_deleted\", \"provider\", \"nice_name\", \"domain_names\", \"expires_on\", \"meta\") VALUES (1, '2022-02-06 18:49:22', '2022-02-06 18:49:22', 1, 0, 'other', 'Wild Card Minhazul', '[\"*.minhazul.com\"]', '2022-05-03 15:58:46', '{ \"certificate\": \"$(sudo cat /etc/letsencrypt/live/minhazul.com/cert.pem )\", \"certificate_key\": \"$(sudo cat /etc/letsencrypt/live/minhazul.com/privkey.pem)\"}');" > nginx_meta

cat nginx_meta

sudo sqlite3 database/nginx_proxymanager/database.sqlite

Paste the command from the nginx_meta file in here
