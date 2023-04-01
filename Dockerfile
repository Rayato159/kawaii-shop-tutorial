FROM golang:1.20-alpine

WORKDIR /app

COPY . ./
RUN go mod download

RUN go build main.go

CMD [ "/app/main", "/app/.env.prod"]