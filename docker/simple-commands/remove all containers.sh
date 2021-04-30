docker container ls -a
docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)
docker container ls -a
#remove all
docker container stop $(docker container ls -aq) && docker system prune -af --volumes


sudo docker container stop $(sudo docker container ls -aq) && sudo docker container rm $(sudo docker container ls -aq)