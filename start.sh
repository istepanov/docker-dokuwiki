#!/bin/sh

set -e

chown -R www-data:www-data /var/www
chown -R www-data:www-data /var/dokuwiki-storage

exec /usr/bin/supervisord -c /etc/supervisord.conf
