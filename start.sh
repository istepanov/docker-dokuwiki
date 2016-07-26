#!/bin/sh

set -e

if ! [ -e /var/dokuwiki-storage/data ]; then
    mkdir -p /var/www /var/dokuwiki-storage/data
fi

for dir in data/pages data/meta data/media data/media_attic data/media_meta data/attic conf; do
    if ! [ -e /var/dokuwiki-storage/$dir ]; then
        cp -r /var/www/$dir /var/dokuwiki-storage/$dir
    fi
    rm -rf /var/www/$dir
    ln -s /var/dokuwiki-storage/$dir /var/www/$dir
done

chown -R www-data:www-data /var/www
chown -R www-data:www-data /var/dokuwiki-storage

exec /usr/bin/supervisord -c /etc/supervisord.conf
