FROM alpine:3.18

LABEL org.opencontainers.image.authors="Simon Rupf <simon@rupf.net>" \
      org.opencontainers.image.source=https://github.com/deadda7a/docker-amavis \
      org.opencontainers.image.version="${VERSION}"

COPY src /usr/local/bin

RUN apk upgrade --no-cache && \
    apk add --no-cache amavis cabextract 7zip patch perl-dbd-mysql \
        perl-io-socket-ssl perl-mail-spf tzdata && \
    # configure amavisd
    patch /etc/amavisd.conf /usr/local/bin/amavisd.conf.patch && \
    echo "1;" > /etc/amavisd-local.conf && \
    chmod o+r /etc/amavisd.conf && \
    rm /usr/local/bin/*.patch && \
    apk del --no-cache patch

WORKDIR /var/amavis
USER amavis:amavis

EXPOSE 10024/tcp
VOLUME /var/amavis /tmp

CMD start.sh
HEALTHCHECK CMD health.sh
