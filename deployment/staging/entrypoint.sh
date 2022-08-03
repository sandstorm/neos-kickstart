#!/bin/bash
set -ex

./flow doctrine:migrate

# only run site import when nothing was imported before
importedSites=`./flow site:list`
if [ "$importedSites" = "No sites available" ]; then
    echo "Importing content from ./ContentDump"
    ./ContentDump/importSite.sh
fi

# create user
./flow user:create --roles Administrator $NEOS_BACKEND_ADMIN_USERNAME $NEOS_BACKEND_ADMIN_PASSWORD LocalDev Admin || true

./flow flow:cache:flush
./flow cache:warmup

# start nginx
nginx &

exec /usr/local/sbin/php-fpm
