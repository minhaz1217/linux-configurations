# Dockerfile.production
# The build stage
FROM golang:1.16-buster as builder
ENV APP_NAME basic-go-api
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /$APP_NAME ./src/main.go

# The run stage
FROM scratch
ENV APP_NAME basic-go-api
COPY --from=builder /$APP_NAME .
EXPOSE 3000
CMD ["./basic-go-api"]

# first browse to the proejct directory then run these
# docker build -t i_basic_go_api .
# docker run -it --rm -p 3000:3000 --name=basic_go_api i_basic_go_api
# docker run -it --rm -p 3000:3000 --name=basic_go_api minhaz1217/basic_go_api

# Now hit it using
# curl localhost:3000