# Development
FROM golang:1.25.0-alpine AS development

WORKDIR /app
COPY go.mod go.sum ./
RUN apk add --no-cache git
RUN go install github.com/air-verse/air@latest

RUN go mod download 

COPY . .

RUN CGO_ENABLED=0 go build -o /server .


CMD ["air", "-c", ".air.toml"]

# Production
FROM alpine:3.20 AS production

WORKDIR /app

COPY --from=development /server /server

CMD [ "/server" ]


