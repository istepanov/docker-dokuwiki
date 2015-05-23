FROM ubuntu:14.04
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

RUN apt-get update && \
    apt-get install -y nginx php5-fpm php5-gd curl && \
    rm -rf /var/lib/apt/lists/*

ENV DOKUWIKI_VERSION 2014-09-29d
ENV SHA1_CHECKSUM 2bf2d6c242c00e9c97f0647e71583375

RUN mkdir -p /var/www \
    && cd /var/www \
    && curl -O "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" \
    && echo "$SHA1_CHECKSUM  dokuwiki-$DOKUWIKI_VERSION.tgz" | md5sum -c - \
    && tar xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 \
    && rm "dokuwiki-$DOKUWIKI_VERSION.tgz"

RUN chown -R www-data:www-data /var/www

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*
ADD dokuwiki.conf /etc/nginx/sites-enabled/

EXPOSE 80
VOLUME [ \
    "/var/www/data/pages", \
    "/var/www/data/meta", \
    "/var/www/data/media", \
    "/var/www/data/media_attic", \
    "/var/www/data/media_meta", \
    "/var/www/data/attic", \
    "/var/www/conf", \
    "/var/log" \
]

CMD /usr/sbin/php5-fpm && /usr/sbin/nginx
