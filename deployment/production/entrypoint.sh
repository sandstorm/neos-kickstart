#!/bin/bash
set -ex

./flow doctrine:migrate
./flow resource:publish

# start nginx
nginx &

exec /usr/local/sbin/php-fpm
