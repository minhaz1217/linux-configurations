# Windows CMD
`set DOCKER_VOLUMES_ROOT=D:/MyComputer/database`

# Windows bash
`export DOCKER_VOLUMES_ROOT=D:/MyComputer/database`

# Linux
`export DOCKER_VOLUMES_ROOT=$HOME/database`


`echo %DOCKER_VOLUMES_ROOT%`

`echo $DOCKER_VOLUMES_ROOT`

# Creating alias
```
alias docker="podman"
```

-p <host_port>:<container_port>

# Busybox
`docker run -it --rm busybox`


# MySQL
[Source](https://hub.docker.com/_/mysql)


`docker run --name mysql -p 3306:3306 -v $DOCKER_VOLUMES_ROOT/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=minhaz -d mysql:latest`


# Postgres
`docker run --name postgres --network minhazul-net -p 5432:5432 -v $DOCKER_VOLUMES_ROOT/postgres:/var/lib/postgresql/data -e POSTGRES_USER=minhaz -e POSTGRES_PASSWORD=minhaz -e PGDATA=/var/lib/postgresql/data/pgdata -d postgres:latest`

`sudo docker run -dit --name postgres --network minhazul-net -p 5432:5432 --restart always -v $DOCKER_VOLUMES_ROOT/postgres:/var/lib/postgresql/data -e POSTGRES_USER=minhaz -e POSTGRES_PASSWORD=minhaz -e PGDATA=/var/lib/postgresql/data/pgdata postgres:14.6`

# PgAdmin
`docker run -d --name pgadmin --network minhazul-net -e PGADMIN_DEFAULT_EMAIL=minhaz@minhazul.com -e PGADMIN_DEFAULT_PASSWORD=minhaz dpage/pgadmin4`

# MongoDB
`docker run --name mongo -p 27017:27017 -v $DOCKER_VOLUMES_ROOT/mongodb:/data/db -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=minhaz --network minhazul-net -d mongo`

# Mongo compass
`docker run -d --name mongo-express --network minhazul-net -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" -e ME_CONFIG_MONGODB_SERVER="mongo" -e ME_CONFIG_MONGODB_ADMINUSERNAME="mongoadmin" -e ME_CONFIG_MONGODB_ADMINPASSWORD="minhaz" -e ME_CONFIG_BASICAUTH_USERNAME="mongominhaz" -e ME_CONFIG_BASICAUTH_PASSWORD="minhaz123" mongo-express`

# General docker commands
## See logs:
`docker exec -it some-mongo bash` \
`docker logs some-mongo`

# Neo4j
`docker run -d --name neo4j -v %DOCKER_VOLUMES_ROOT%/neo4j:/data --publish=7474:7474 --publish=7473:7473 --publish=7687:7687 neo4j`

# ElasticSearch
data02:/usr/share/elasticsearch/data

`docker run -d --name elasticsearch -v %DOCKER_VOLUMES_ROOT%/elasticsearch:/usr/share/elasticsearch/data -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.15.1`

## backup elastic search
### 1. Register a repository
yum install nano \
nano /usr/share/elasticsearch/config/elasticsearch.yml \
path.repo: ["/usr/share/elasticsearch/data/backups"]


```
PUT /_snapshot/my_backup
{
  "type" : "fs",
  "settings" : {
    "location" : "/usr/share/elasticsearch/data/backups/newbackup"
  }
}
```

#### GET /_snapshot/_all

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
`PUT /_snapshot/my_backup/snapshot_name?wait_for_completion=true`

```PUT /_snapshot/my_backup/<snapshot-{now/d}>``` \
```PUT /_snapshot/my_backup/%3Csnapshot-%7Bnow%2Fd%7D%3E?wait_for_completion=true```

### 4. find the snapshots
`GET /_snapshot`

`GET /_snapshot/_all`

`GET /_snapshot/my_backup`

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
docker run -d --name kibana -v %DOCKER_VOLUMES_ROOT%/kibana:/usr/share/kibana/data -p 5601:5601 --link elasticsearch:elasticsearch docker.elastic.co/kibana/kibana:7.15.1

# Cassandra
docker run --name cassandra -v %DOCKER_VOLUMES_ROOT%/cassandra:/var/lib/cassandra -d cassandra:latest

### Get IP of container
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id

# Installing apps
docker run --name grandnode2 -p 8001:80 -d grandnode2image
docker run --name nopcommerce -p 8002:80 -d nopcommerceimage

mongodb://mongoadmin:minhaz@172.17.0.3:27017/grandnode2?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&ssl=false

# Nginx
## First copy the nginx config file from a temp container
`mkdir -p %DOCKER_VOLUMES_ROOT%/nginx/nginx/`

sudo podman run --name nginx -v $DOCKER_VOLUMES_ROOT/nginx/nginx:/etc/nginx -v $DOCKER_VOLUMES_ROOT/nginx/cert:/etc/ssl/private -p 80:80 -p 443:443 --network minhazul-net -d nginx

```
docker run --name tmp-nginx-container -d nginx
docker cp tmp-nginx-container:/etc/nginx/ %DOCKER_VOLUMES_ROOT%/nginx/
docker cp tmp-nginx-container:/etc/nginx/nginx.conf %DOCKER_VOLUMES_ROOT%/nginx
docker rm -f tmp-nginx-container
```
## Run the nginx
`docker run --name nginx --net-alias nginx -v %DOCKER_VOLUMES_ROOT%/nginx/nginx:/etc/nginx -v %DOCKER_VOLUMES_ROOT%/nginx/cert:/etc/ssl/private -p 80:80 -p 443:443 --network minhazul-net -d nginx`

## After run
`mkdir %DOCKER_VOLUMES_ROOT%/nginx/nginx/conf.d/sites-available`

`mkdir %DOCKER_VOLUMES_ROOT%/nginx/nginx/conf.d/sites-enabled`

## Create file in sites-available named plex.conf
```
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
```
## Go into sites-enabled open bash
`ln -s ../sites-available/portfolio .conf .`

## Open nginx.conf in /nginx folder

### Replace include /etc/nginx/conf.d/*.conf; to `include /etc/nginx/conf.d/sites-enabled/*.conf;`

## Run these commands
`docker exec nginx nginx -t`

`docker exec nginx nginx -s reload`

# Nginx Proxy Manager

`docker run --name nproxy --restart always -v $DOCKER_VOLUMES_ROOT/nginx_proxymanager/:/data -v $DOCKER_VOLUMES_ROOT/nginx_proxymanager/letsencrypt:/etc/letsencrypt -p 80:80 -p 443:443 -p 81:81 --network minhazul-net -dit jc21/nginx-proxy-manager:latest`

docker run --name nproxy --net-alias nginx_proxymanager -v $HOME/nginx_proxymanager2/:/data -v $HOME/nginx_proxymanager2/letsencrypt:/etc/letsencrypt -p 80:80 -p 443:443 -p 81:81 -p3000:3000 --network minhazul-net -dit jc21/nginx-proxy-manager:latest

## To create a symlink
`ln -sf /path/to/file /path/to/symlink`


`ln -sf /etc/letsencrypt/live/minhazul.com/privkey.pem ~/database/nginx_proxymanager/custom_ssl/npm-1/privkey.pem`
`ln -sf /etc/letsencrypt/live/minhazul.com/fullchain.pem ~/database/nginx_proxymanager/custom_ssl/npm-1/fullchain.pem`


`docker pull jc21/nginx-proxy-manager:github-develop`
## Create a network
`docker network create -d bridge minhazul-net`

## Localhost ip from inside the docker
`172.17.0.1`

# Adminer
`docker run --name adminer -p 8006:8080 -it -d adminer`

# Etherpad
`docker run -dit --name etherpad --network minhazul-net -e DB_TYPE=postgres -e DB_HOST=postgres -e DB_PORT=5432 -e DB_NAME=etherpad -e DB_USER=minhaz -e DB_PASS=minhaz etherpad/etherpad`

# Proxy SQL
`docker run -it -d --name proxysql --network minhazul-net -p 16032:6032 -p 16033:6033 -p 16070:6070 -d -v %DOCKER_VOLUMES_ROOT%/proxysql/proxysql.cnf:/etc/proxysql.cnf -v %DOCKER_VOLUMES_ROOT%/proxysql/data:/var/lib/proxysql proxysql/proxysql`

# Prometheus

`docker run -d -it --network minhazul-net --name=prometheus -v $DOCKER_VOLUMES_ROOT/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus`

`docker run -p 9090:9090 -v %DOCKER_VOLUMES_ROOT%/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus`


`docker run -d -it --network minhazul-net --name=prometheus -p 9090:9090 -v %DOCKER_VOLUMES_ROOT%/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v %DOCKER_VOLUMES_ROOT%/prometheus/data:/prometheus/ prom/prometheus`

## Prometheus - Node exporter
`docker run -d -it --network minhazul-net --name=node-exporter -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host`

## Prometheus - Cadvisor
`sudo docker run --network minhazul-net --name=cadvisor --volume=/:/rootfs:ro --volume=/var/run:/var/run:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --detach=true  --privileged --device=/dev/kmsg gcr.io/cadvisor/cadvisor`

# Grafana
`echo $UID`

`sudo docker run -d  --name grafana --network minhazul-net -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource"  grafana/grafana-oss`


`docker run -d -it --network minhazul-net --name grafana -v $DOCKER_VOLUMES_ROOT/grafana:/var/lib/grafana -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource"  grafana/grafana-enterprise`


`docker run -d -it --network minhazul-net --name node-exporter -v "%DOCKER_VOLUMES_ROOT%/prometheus/node-exporter/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host`

`sudo docker run -d -it --network minhazul-net --name=cadvisor --volume=%DOCKER_VOLUMES_ROOT%/prometheus/cadvisor/:/rootfs:ro --volume=%DOCKER_VOLUMES_ROOT%/prometheus/cadvisor/var/run:/var/run:ro --volume=%DOCKER_VOLUMES_ROOT%/prometheus/cadvisor/sys:/sys:ro --volume=%DOCKER_VOLUMES_ROOT%/prometheus/cadvisor/var/lib/docker/:/var/lib/docker:ro --volume=%DOCKER_VOLUMES_ROOT%/prometheus/cadvisor/dev/disk/:/dev/disk:ro --publish=8080:8080 --detach=true --name=cadvisor --privileged gcr.io/cadvisor/cadvisor`

# Loki
`wget https://raw.githubusercontent.com/grafana/loki/v2.4.2/cmd/loki/loki-local-config.yaml -O loki-config.yaml`

`docker run -d -it --network minhazul-net --name loki -v $DOCKER_VOLUMES_ROOT/loki:/mnt/config -v $DOCKER_VOLUMES_ROOT/loki/data:/tmp/loki grafana/loki:2.4.2 -config.file=/mnt/config/loki-config.yaml`


#### loki-config.yaml
```
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  path_prefix: /tmp/loki
  storage:
    filesystem:
      chunks_directory: /tmp/loki/chunks
      rules_directory: /tmp/loki/rules
  replication_factor: 1
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2020-01-19
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h
```


# Promtail 
`wget https://raw.githubusercontent.com/grafana/loki/v2.4.2/clients/cmd/promtail/promtail-docker-config.yaml -O promtail-config.yaml`

`docker run -it -d --network minhazul-net --name promtail -v $DOCKER_VOLUMES_ROOT/promtail:/mnt/config -v /var/log:/var/log  grafana/promtail:2.4.2 -config.file=/mnt/config/promtail-config.yaml`


`docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions`
`sudo nano /etc/docker/daemon.json`

#### promtail-config.yaml
```
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

# System logs
scrape_configs:
- job_name: system
  static_configs:
  - targets:
      - localhost
    labels:
      job: varlogs
      __path__: /var/log/*log

# Docker logs
- job_name: docker
  pipeline_stages:
    - docker: {}
  static_configs:
  - targets:
      - localhost
    labels:
      job: docker
      __path__: /var/lib/docker/containers/*/*-json.log

```

# Jenkins
`docker run --name jenkins -p 8081:8080 -p 50000:50000 -dit -v %DOCKER_VOLUMES_ROOT%/jenkins/data:/var/jenkins_home jenkins/jenkins:lts-jdk11`

docker run --name jenkins -p 8081:8080 -p 50000:50000 -dit jenkins/jenkins:lts-jdk11

### Run this to see the secret key for admin access at `localhost:8080`
`docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`


<!-- `docker network create jenkins`

`docker run --name jenkins-docker -dit --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume %DOCKER_VOLUMES_ROOT%/jenkins/certs:/certs --volume %DOCKER_VOLUMES_ROOT%/jenkins/data:/var/jenkins_home --publish 2376:2376 docker:dind --storage-driver overlay2`


`openssl ca -config openssl.cnf -extensions client -batch -out test.cert`

`sudo openssl x509 -outform der -in cert.pem -out cert.crt`

openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt


openssl genrsa -out client.key 4096   
openssl req -new -x509 -text -key client.key -out client.cert -->

# OpenVPN
## At first create a volume and generate necessary files in it
`sudo docker run -v $DOCKER_VOLUMES_ROOT/openvpn:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://vpn.minhazul.com`

`sudo docker run -v $DOCKER_VOLUMES_ROOT/openvpn:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki`

## Start the openvpn
`sudo docker run --name openvpn -v $DOCKER_VOLUMES_ROOT/openvpn:/etc/openvpn -dit -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn`

## Generate client config
`export vpn_username=minhaz-mobile`
`sudo docker run -v $DOCKER_VOLUMES_ROOT/openvpn:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $vpn_username nopass`

## Retrive the generated file
`sudo docker run -v $DOCKER_VOLUMES_ROOT/openvpn:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $vpn_username > $vpn_username.ovpn`

### See the file
```
cat $vpn_username.ovpn
```

### If any problem with permission
```
podman run --name openvpn -v $DOCKER_VOLUMES_ROOT/openvpn:/etc/openvpn -dit -p 1049:1194/udp --privileged kylemanna/openvpn
```
# Zookeeper
### Install using
`docker run --name zookeeper --restart always -dit -p 4001:2181 -p 4002:2888 -p 4003:3888 -p 4004:8080 -v $DOCKER_VOLUMES_ROOT/zookeeper/conf:/conf -v $DOCKER_VOLUMES_ROOT/zookeeper/data:/data -v $DOCKER_VOLUMES_ROOT/zookeeper/datalog:/datalog zookeeper`

### Install using bitnami zookeeper
`docker run --name zookeeper --rm -it --network zookeeper-ds -p 2181:2181 -e  ALLOW_ANONYMOUS_LOGIN=yes bitnami/zookeeper:latest`


# Code Server
`docker run --name vscode -dit --network localhost-network -e PASSWORD=hellominhaz123 -p 7001:8080 -v $DOCKER_VOLUMES_ROOT/code-server/.config:/home/coder/.config -v D:/MyComputer/website:/home/coder/projects codercom/code-server`

# Rust Server
```
version: '3'

networks:
  minhazul-net:
    external: true
    name: minhazul-net

services:
  hbbs:
    container_name: hbbs
    ports:
      - 21115:21115
      - 21116:21116
      - 21116:21116/udp
      - 21118:21118
    image: rustdesk/rustdesk-server:latest
    command: hbbs -r minhazul.com:21117
    volumes:
      - ~/database/rust-server/hbbs:/root
    networks:
      - minhazul-net
    depends_on:
      - hbbr
    restart: unless-stopped

  hbbr:
    container_name: hbbr
    ports:
      - 21117:21117
      - 21119:21119
    image: rustdesk/rustdesk-server:latest
    command: hbbr
    volumes:
      - ~/database/rust-server/hbbr:/root
    networks:
      - minhazul-net
    restart: unless-stopped
```

### Set up the id and relay server as the host name in the softwares to connect.

# MSSQL
`docker run --name mssql -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Asd123!!" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest`

### Get into the mssql
`docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Asd123!!`

### Get databases 

```
SELECT Name FROM sys.Databases;
GO
```

### Get tables
```
SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO
```

# NocoDB
`docker run -dit --name nocodb --network minhazul-net -v $DOCKER_VOLUMES_ROOT/nocodb:/usr/app/data/ -e NC_DB="pg://postgres:5432?u=minhaz&p=minhaz&d=nocodb" -e NC_AUTH_JWT_SECRET="ae102f21-c03b-4dd8-96a3-6e24959ef0c8" nocodb/nocodb:latest`

# Redis
`docker run -dit --name redis --network minhazul-net -v $DOCKER_VOLUMES_ROOT/redis:/data -p 6379:6379 redis redis-server --save 60 1 --loglevel warning`

# Redis insight
`docker run -dit --name redisinsight --network minhazul-net -v $DOCKER_VOLUMES_ROOT/redisinsight:/db redislabs/redisinsight:latest`

# Portainer
`docker run -d --network minhazul-net --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v $DOCKER_VOLUMES_ROOT/portainer:/data portainer/portainer-ce:latest`


# Trilium Journal 
sudo docker run --name trilium -it -p8080:8080 -v $DOCKER_VOLUMES_ROOT/trilium:/home/node/trilium-data zadam/trilium

# Seq
```
PH=$(echo 'minhazseq123456%%' | docker run --rm -i datalust/seq config hash)

docker run --name seq -d --network minhazul-net --restart unless-stopped -e ACCEPT_EULA=Y -e SEQ_FIRSTRUN_ADMINPASSWORDHASH="$PH" -v $DOCKER_VOLUMES_ROOT/seq/data:/data datalust/seq

docker run --name seq -d --restart unless-stopped -e ACCEPT_EULA=Y -e SEQ_FIRSTRUN_ADMINPASSWORDHASH="QOl8fDOsBiz82GXF5E87qCrWaogV9dnQIcqdIXCNIEJaf6aFBPZ3DXevxTCWuFRXV7h3yAd2UP2VdzVphbGvpqWDKsus5v2x4eyVWOhT04qc" -v $DOCKER_VOLUMES_ROOT/seq/data:/data -p 5341:5341 datalust/seq
```

http://localhost:5341/#/dashboards?dashboardId=dashboard-14&range=2h&group=1m&
refresh=10s&apiKey=QOl8fDOsBiz82GXF5E87qCrWaogV9dnQIcqdIXCNIEJaf6aFBPZ3DXevxTCWuFRXV7h3yAd2UP2VdzVphbGvpqWDKsus5v2x4eyVWOhT04qc&theme=dark-theme&maximized


# SonarQube
```
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 -v $DOCKER_VOLUMES_ROOT/sonarqube/data:/opt/sonarqube/data -v $DOCKER_VOLUMES_ROOT/sonarqube/extensions:/opt/sonarqube/extensions -v $DOCKER_VOLUMES_ROOT/sonarqube/logs:/opt/sonarqube/logs sonarqube:latest
```
```
docker run -d --name sonarqube \
    -p 9000:9000 \
    -e SONAR_JDBC_URL=... \
    -e SONAR_JDBC_USERNAME=... \
    -e SONAR_JDBC_PASSWORD=... \
    -v sonarqube_data:/opt/sonarqube/data \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    -v sonarqube_logs:/opt/sonarqube/logs \
```

# Uptime kuma
```
docker run -d --network minhazul-net --name uptime --restart=always -p 3001:3001 -v $DOCKER_VOLUMES_ROOT/uptime-kuma:/app/data louislam/uptime-kuma:1
```


# Allure
```
docker run -dit --network minhazul-net --name allure-service -p 5050:5050 -e CHECK_RESULTS_EVERY_SECONDS=3 -e KEEP_HISTORY=1 -v $DOCKER_VOLUMES_ROOT/allure/allure-results:/app/allure-results -v $DOCKER_VOLUMES_ROOT/allure/allure-reports:/app/default-reports frankescobar/allure-docker-service


docker run -dit --network minhazul-net --name allure-ui -p 5252:5252 -e ALLURE_DOCKER_PUBLIC_API_URL=http://localhost:5050 frankescobar/allure-docker-service-ui
```


# Abstruse CI/CD
```
docker run -dit --restart always -v $DOCKER_VOLUMES_ROOT/abstruse/abstruse-config:/root/abstruse -p 6500:6500 bleenco/abstruse
```