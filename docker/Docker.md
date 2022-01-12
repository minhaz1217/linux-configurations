# MySQL
https://hub.docker.com/_/mysql

`docker run --name mysql -p 3306:3306 -v D:/MyComputer/database/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=minhaz -d mysql:latest`


# Postgres
`docker run --name postgres -p 5432:5432 -v D:/MyComputer/database/postgres:/var/lib/postgresql/data -e POSTGRES_USER=minhaz -e POSTGRES_PASSWORD=minhaz -e PGDATA=/var/lib/postgresql/data/pgdata -d postgres:latest`

# MongoDB
`docker run --name mongo -p 27017:27017 -v D:/MyComputer/database/mongodb:/data/db -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=minhaz -d mongo`

# General docker commands
## See logs:
`docker exec -it some-mongo bash`

`docker logs some-mongo`

# Neo4j
`docker run -d --name neo4j -v D:/MyComputer/database/neo4j:/data --publish=7474:7474 --publish=7473:7473 --publish=7687:7687 neo4j`

# ElasticSearch
data02:/usr/share/elasticsearch/data

`docker run -d --name elasticsearch -v D:/MyComputer/database/elasticsearch:/usr/share/elasticsearch/data -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.15.1`
## backup elastic search
### 1. Register a repository
yum install nano
nano /usr/share/elasticsearch/config/elasticsearch.yml
path.repo: ["/usr/share/elasticsearch/data/backups"]


PUT /_snapshot/my_backup
{
  "type" : "fs",
  "settings" : {
    "location" : "/usr/share/elasticsearch/data/backups/newbackup"
  }
}
GET /_snapshot/_all

### 2. create a repository in the same location as repo.path
```
PUT /_snapshot/my_backup
{
  "type" : "fs",
  "settings" : {
    "location" : "/usr/share/elasticsearch/data/backups/my_backup"
  }
}
```

### 3. creating snapshot
PUT /_snapshot/my_backup/snapshot_name?wait_for_completion=true

PUT /_snapshot/my_backup/<snapshot-{now/d}>
PUT /_snapshot/my_backup/%3Csnapshot-%7Bnow%2Fd%7D%3E?wait_for_completion=true

### 4. find the snapshots
GET /_snapshot
GET /_snapshot/_all
GET /_snapshot/my_backup
GET /_snapshot/my_backup/_all
GET /_snapshot/my_backup/_current
GET /_snapshot/_status

### 5. restore the snapshots
#### all
POST /_snapshot/my_backup/snapshot_name/_restore
#### single or multiple ( comman seperated ) indices
POST /_snapshot/my_backup/snapshot_name/_restore
{
  "indices": "favorite_candy",
  "ignore_unavailable": true,
  "include_global_state": false,              
  "rename_pattern": "index_(.+)",
  "rename_replacement": "restored_index_$1",
  "include_aliases": false
}
# Kibana
docker run -d --name kibana -v D:/MyComputer/database/kibana:/usr/share/kibana/data -p 5601:5601 --link elasticsearch:elasticsearch docker.elastic.co/kibana/kibana:7.15.1

# Cassandra
docker run --name cassandra -v D:/MyComputer/database/cassandra:/var/lib/cassandra -d cassandra:latest

### Get IP of container
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id

# Installing apps
docker run --name grandnode2 -p 8001:80 -d grandnode2image
docker run --name nopcommerce -p 8002:80 -d nopcommerceimage

mongodb://mongoadmin:minhaz@172.17.0.3:27017/grandnode2?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&ssl=false

# Nginx
## First copy the nginx config file from a temp container
mkdir D:/MyComputer/database/nginx/nginx/
docker run --name tmp-nginx-container -d nginx
docker cp tmp-nginx-container:/etc/nginx/ D:/MyComputer/database/nginx/
docker cp tmp-nginx-container:/etc/nginx/nginx.conf D:/MyComputer/database/nginx/nginx
docker rm -f tmp-nginx-container

## Run the nginx
docker run --name nginx --net-alias nginx -v D:/MyComputer/database/nginx/nginx:/etc/nginx -v D:/MyComputer/database/nginx/cert:/etc/ssl/private -p 80:80 -p 443:443 --network minhazul-net -d nginx

## After run
mkdir D:/MyComputer/database/nginx/nginx/conf.d/sites-available
mkdir D:/MyComputer/database/nginx/nginx/conf.d/sites-enabled

## Create file in sites-available named plex.conf
upstream plex {
  server        plex:32400;
}

server {
  listen        80;
  server_name   plex.example.com;

  location / {
    proxy_pass  http://plex;
  }
}

## Go into sites-enabled open bash
ln -s ../sites-available/portfolio.conf .

## Open nginx.conf in /nginx folder
## Replace include /etc/nginx/conf.d/*.conf; to `include /etc/nginx/conf.d/sites-enabled/*.conf;`

## Run these commands
docker exec nginx nginx -t
docker exec nginx nginx -s reload

# Nginx Proxy Manager

`docker run --name nginx_proxymanager --net-alias nginx_proxymanager -v D:/MyComputer/database/nginx_proxymanager/:/data -v D:/MyComputer/database/nginx_proxymanager/letsencrypt:/etc/letsencrypt -p 80:80 -p 443:443 -p 81:81 --network minhazul-net -d jc21/nginx-proxy-manager:latest`

## Create a network
docker network create -d bridge minhazul-net

## Localhost ip from inside the docker
172.17.0.1

# Adminer
docker run --name adminer -p 8006:8080 -it -d adminer

# Mongo compass
docker run -it -d --name mongo-express -p 8007:8081 -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" -e ME_CONFIG_MONGODB_SERVER="172.17.0.1" -e ME_CONFIG_MONGODB_ADMINUSERNAME="mongoadmin" -e ME_CONFIG_MONGODB_ADMINPASSWORD="minhaz" -e ME_CONFIG_BASICAUTH_USERNAME="mongominhaz" -e ME_CONFIG_BASICAUTH_PASSWORD="minhaz" mongo-express

