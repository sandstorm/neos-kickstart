#!/bin/sh
set -ex

composer install

./flow doctrine:migrate
./flow site:import --package-key $SITE_IMPORT_PACKAGE_KEY
./flow user:create --roles Administrator $ADMIN_USERNAME $ADMIN_PASSWORD LocalDev Admin
./flow resource:publish

# run command
exec "$@"
