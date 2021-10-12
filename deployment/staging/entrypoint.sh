#!/bin/bash
set -ex

./flow doctrine:migrate

./flow site:import --package-key $SITE_IMPORT_PACKAGE_KEY

./flow resource:publish

./flow flow:cache:flush
./flow cache:warmup

# configure nginx
envsubst '\$NGINX_HOST \$NGINX_PORT' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf

# start nginx
nginx &

exec /usr/local/sbin/php-fpm
