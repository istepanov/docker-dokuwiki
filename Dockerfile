FROM ubuntu:14.04
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys E5267A6C && \
    echo 'deb http://ppa.launchpad.net/ondrej/php5/ubuntu trusty main' > /etc/apt/sources.list.d/ondrej-php5-trusty.list && \
    apt-get update && \
    apt-get install -y supervisor nginx php5-fpm php5-gd curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV DOKUWIKI_VERSION 2015-08-10a
ENV MD5_CHECKSUM a4b8ae00ce94e42d4ef52dd8f4ad30fe

RUN mkdir -p /var/www /var/dokuwiki-storage/data && \
    cd /var/www && \
    curl -O "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    echo "$MD5_CHECKSUM  dokuwiki-$DOKUWIKI_VERSION.tgz" | md5sum -c - && \
    tar xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 && \
    rm "dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    mv /var/www/data/pages /var/dokuwiki-storage/data/pages && \
    ln -s /var/dokuwiki-storage/data/pages /var/www/data/pages && \
    mv /var/www/data/meta /var/dokuwiki-storage/data/meta && \
    ln -s /var/dokuwiki-storage/data/meta /var/www/data/meta && \
    mv /var/www/data/media /var/dokuwiki-storage/data/media && \
    ln -s /var/dokuwiki-storage/data/media /var/www/data/media && \
    mv /var/www/data/media_attic /var/dokuwiki-storage/data/media_attic && \
    ln -s /var/dokuwiki-storage/data/media_attic /var/www/data/media_attic && \
    mv /var/www/data/media_meta /var/dokuwiki-storage/data/media_meta && \
    ln -s /var/dokuwiki-storage/data/media_meta /var/www/data/media_meta && \
    mv /var/www/data/attic /var/dokuwiki-storage/data/attic && \
    ln -s /var/dokuwiki-storage/data/attic /var/www/data/attic && \
    mv /var/www/conf /var/dokuwiki-storage/conf && \
    ln -s /var/dokuwiki-storage/conf /var/www/conf

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*
ADD dokuwiki.conf /etc/nginx/sites-enabled/

ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
VOLUME ["/var/dokuwiki-storage"]

CMD /start.sh
