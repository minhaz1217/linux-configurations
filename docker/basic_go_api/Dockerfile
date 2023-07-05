# Dockerfile.production
# The build stage
FROM golang:1.16-buster as builder
ENV APP_USER app-user
ENV APP_HOME /go
ENV APP_NAME basic-go-api
RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME && chown -R $APP_USER:$APP_USER $APP_HOME
USER $APP_USER
WORKDIR $APP_HOME
COPY . .
RUN go build -o $APP_NAME ./src/main.go

FROM debian:stable-slim
ENV APP_USER app
ENV APP_HOME /go
ENV APP_NAME basic-go-api
RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY --chown=0:0 --from=builder $APP_HOME/$APP_NAME $APP_HOME
EXPOSE 3000
USER $APP_USER
# CMD ["./"$APP_NAME]
CMD ["./basic-go-api"]

# first browse to the proejct directory then run these
# docker build -t i_basic_go_api .
# docker run -it --rm -p 3000:3000 --name=basic_go_api i_basic_go_api
# Now hit it using
# curl localhost:3000