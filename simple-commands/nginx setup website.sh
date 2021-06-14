customDomain="app.example.com"
user=$(USER)


sudo mkdir -p /var/www/$customDomain/html
sudo chown -R $USER:$USER /var/www/$customDomain/html
sudo chmod -R 755 /var/www/$customDomain


cat > /var/www/$customDomain/html/index.html <<- EOM
<html>
    <head>
        <title>Welcome to $customDomain!</title>
    </head>
    <body>
        <h1>Success!  The $customDomain server block is working!</h1>
    </body>
</html>
EOM

# create the side config
# sudo nano /etc/nginx/sites-available/$customDomain
cat > /etc/nginx/sites-available/$customDomain <<- EOM
server {
        listen 80;
        listen [::]:80;

        root /var/www/$customDomain/html;
        index index.html index.htm index.nginx-debian.html;

        server_name $customDomain www.$customDomain;

        location / {
                try_files $uri $uri/ =404;
        }
}
EOM

sudo ln -s /etc/nginx/sites-available/$customDomain /etc/nginx/sites-enabled/

sudo nginx -t
sudo systemctl restart nginx


