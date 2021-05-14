FROM golang:1.15.7-buster

WORKDIR /app
ENTRYPOINT ["go", "run", "main.go"]

# first browse to the proejct directory then run these
# docker build -t goimg .
# sudo docker run -it --rm -p 8010:3002 --name=goapp -v $PWD/src:/app goimg
