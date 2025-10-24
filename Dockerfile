# syntax=docker/dockerfile:1
FROM golang:1.25-alpine AS builder

ARG VERSION
ARG VCS_REF
ARG BUILD_DATE

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.title="emailai" 
LABEL org.opencontainers.image.description="Worker pool based application for processing emails"
LABEL org.opencontainers.image.url="https://github.com/blind3dd/emailai"

WORKDIR /src
RUN apk add --no-cache git build-base
COPY go.mod ./
COPY go.sum ./
RUN go mod download
COPY . .
ENV GOFLAGS='-ldflags=-s -w'
ENV CGO_ENABLED=0
RUN GODEBUG=netdns=go go build -o /out/emailai ./cmd/emailai

FROM alpine:3.20
ARG USER=app
ARG UID=10001
ARG GID=10001
ARG DNS_MODE=auto
ENV DNS_MODE=${DNS_MODE}

# Install runtime deps
RUN apk add --no-cache ca-certificates tzdata busybox libc6-compat openssl && \
    update-ca-certificates

# Create non-root user/group
RUN addgroup -g ${GID} ${USER} && \
    adduser -D -H -u ${UID} -G ${USER} ${USER}

ENV TZ=UTC \
    EMAILAI_WORKERS=5 \
    EMAILAI_TASKS=100 \
    EMAILAI_LOG_LEVEL=info

COPY --from=builder /out/emailai /usr/local/bin/emailai

# Security: ensure binary is not suid/sgid
RUN chmod 0755 /usr/local/bin/emailai

USER ${USER}:${USER}
WORKDIR /home/${USER}
ENV TZ=UTC

# Simple startup preflight: user and group must exist; no root
ENTRYPOINT ["/bin/sh","-lc","\
    if [ \"$DNS_MODE\" = auto ]; then \
    if ldd --version 2>&1 | grep -qi musl || ls /lib/ld-musl-* >/dev/null 2>&1; then \
    export GODEBUG=${GODEBUG:-netdns=go}; \
    fi; \
    elif [ \"$DNS_MODE\" = go ]; then \
    export GODEBUG=netdns=go; \
    fi; \
    id && getent passwd $(whoami) >/dev/null && getent group $(id -gn) >/dev/null && exec /usr/local/bin/emailai"]