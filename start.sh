#!/bin/sh

set -e

chown -R www-data:www-data /var/www
chown -R www-data:www-data /var/dokuwiki-storage

su -s /bin/bash www-data -c 'php /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
