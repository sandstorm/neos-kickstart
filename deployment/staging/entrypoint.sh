#!/bin/bash
set -ex

./flow doctrine:migrate

# NOTE: for Staging and PROD, we do not import the content dump here, as usually you want to do it
# in a more controlled way.

# NOTE: for Staging and PROD, we do not create users here, as we want secure users and passwords.

./flow resource:publish
./flow flow:cache:flush
./flow cache:warmup


# start nginx
nginx &

exec /usr/local/sbin/php-fpm
