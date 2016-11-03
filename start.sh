#!/bin/sh

set -e

chown -R nobody /var/www
chown -R nobody /var/dokuwiki-storage

su -s /bin/sh nobody -c 'php7 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
