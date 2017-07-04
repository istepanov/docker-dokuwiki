#!/bin/sh

set -e

chown -R nginx /var/www
chown -R nginx /var/dokuwiki-storage

su -s /bin/sh nginx -c 'php7 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
