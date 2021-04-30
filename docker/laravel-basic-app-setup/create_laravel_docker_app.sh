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
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=$mysqlUser
DB_PASSWORD=$mysqlPassword
EOM



# Run docker compose
sudo docker-compose build
sudo docker-compose up -d
#sudo docker ps

# laravel specific things
sudo docker-compose exec app php artisan key:generate
sudo docker-compose exec app php artisan config:cache
## at this point you can visit the app
