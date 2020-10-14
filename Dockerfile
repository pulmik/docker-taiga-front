#FROM alpine:3.10
FROM nginx:alpine

# ARG VERSION=5.0.12

ENV TAIGA_HOST=taiga.lan \
    TAIGA_PORT=80 \
    TAIGA_SCHEME=http

WORKDIR /srv/taiga

RUN apk --no-cache add nginx \
    && apk add --no-cache --virtual .build-dependencies git \ 
    && rm /etc/nginx/conf.d/default.conf \
    && mkdir /run/nginx \
    && git clone --depth=1 -b stable https://github.com/taigaio/taiga-front-dist.git front \
    && cd front \
    && rm dist/conf.example.json

#RUN apk add --no-cache curl && \
#    rm /etc/nginx/conf.d/default.conf && \
#    mkdir /run/nginx && \
#    curl -#L https://github.com/taigaio/taiga-front-dist/archive/$VERSION-stable.tar.gz > dist.tar.gz && \
#    tar -xzf dist.tar.gz && mv taiga-front-dist-* front && \
#    cd front && \
#    rm dist/conf.example.json

WORKDIR /srv/taiga/front/dist

COPY ../taiga-contrib-gitlab-auth/front/dist gitlab-auth
COPY start.sh /
COPY nginx.conf /etc/nginx/conf.d/
COPY config.json /tmp/taiga-conf/

VOLUME ["/taiga-conf"]

CMD ["/start.sh"]
