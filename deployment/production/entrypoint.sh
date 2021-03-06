#!/bin/bash
set -ex

./flow doctrine:migrate
./flow resource:publish

# configure nginx
envsubst '\$NGINX_HOST \$NGINX_PORT' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf

# start nginx
nginx &

exec /usr/local/sbin/php-fpm
