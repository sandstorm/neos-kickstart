#!/bin/sh
set -ex

composer install

./flow doctrine:migrate

# only run site import when nothing was imported before
importedSites=`./flow site:list`
if [ "$importedSites" = "No sites available" ]; then
    ./flow site:import --package-key $SITE_IMPORT_PACKAGE_KEY
fi

./flow user:create --roles Administrator $ADMIN_USERNAME $ADMIN_PASSWORD LocalDev Admin || true
./flow resource:publish

./flow flow:cache:flush
./flow cache:warmup

# configure nginx
envsubst '\$NGINX_HOST \$NGINX_PORT' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf

# start nginx in background
nginx &

# start PHP-FPM
exec /usr/local/sbin/php-fpm
