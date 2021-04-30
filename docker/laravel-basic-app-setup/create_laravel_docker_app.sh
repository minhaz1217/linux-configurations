# run this file by typing: bash create_laravel_docker_app.sh

currentDirectory=$(pwd)
mysqlPassword="123"
mysqlUser="laraveluser"
# Cloning the basic laravel project
git clone https://github.com/laravel/laravel.git laravel-app

# mysql config
mkdir $currentDirectory/laravel-app/mysql
cp my.cnf $currentDirectory/laravel-app/mysql/my.cnf

# php config
mkdir $currentDirectory/laravel-app/php
cp local.ini $currentDirectory/laravel-app/php/local.ini

# nginx config
mkdir -p $currentDirectory/laravel-app/nginx/conf.d

cp app.conf $currentDirectory/laravel-app/nginx/conf.d/app.conf

# docker configs
cp docker-compose.yml $currentDirectory/laravel-app/docker-compose.yml

sudo chown -R $USER:$USER $currentDirectory/laravel-app

cp Dockerfile $currentDirectory/laravel-app/Dockerfile

cd $currentDirectory/laravel-app

sudo docker run --rm -v $(pwd):/app composer install
## writing to file, the string after cat indicated where it will end, in this case "EOM"
cat > .env <<- EOM
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=$mysqlUser
DB_PASSWORD=$mysqlPassword

BROADCAST_DRIVER=log
CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=null
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_APP_CLUSTER=mt1

MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
EOM



# Run docker compose
sudo docker-compose build
sudo docker-compose up -d
#sudo docker ps

# laravel specific things
sudo docker-compose exec app php artisan key:generate
sudo docker-compose exec app php artisan config:cache
## at this point you can visit the app

# now creating a user for our app to connect in the db
sudo docker-compose exec db bash -c 'mysql -u root -p123 -e "show databases;GRANT ALL ON laravel.* TO \"$(mysqlUser)\"@\"%\" IDENTIFIED BY \"$(mysqlPassword)\";FLUSH PRIVILEGES;"'
sudo docker-compose exec app php artisan migrate

