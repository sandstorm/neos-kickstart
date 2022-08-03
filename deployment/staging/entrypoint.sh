#!/bin/bash
set -ex

./flow doctrine:migrate

# only run site import when nothing was imported before
importedSites=`./flow site:list`
if [ "$importedSites" = "No sites available" ]; then
    echo "Importing content from ./ContentDump"
    ./ContentDump/importSite.sh
fi

./flow flow:cache:flush
./flow cache:warmup

# start nginx
nginx &

exec /usr/local/sbin/php-fpm
