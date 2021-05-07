# build image from docker file
docker build -t image_name .

# see built images
docker images

# remove single image
docker rmi image_name 

# removing all images in system
docker system prune -a

# docker run
docker run -it -d -p80:5000 -name=container_name image_name npm run ec2 --host=0.0.0.0
# see all container
docker ps -a
# remove container
docker rm container_name


# shell in to a container
sudo docker container exec -it container_name bash

# list of container exposed port
docker port container_name


# container running processer
docker container top container_name

# container stats in real time
docker container stats container_name
