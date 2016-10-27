#!/bin/sh

set -e

su -s /bin/bash www-data -c 'php /var/www/bin/indexer.php -c'

chown -R www-data:www-data /var/www
chown -R www-data:www-data /var/dokuwiki-storage

exec /usr/bin/supervisord -c /etc/supervisord.conf
