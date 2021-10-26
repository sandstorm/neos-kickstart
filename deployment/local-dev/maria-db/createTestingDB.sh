#!/bin/bash
set -ex

mysql --password="$MYSQL_ROOT_PASSWORD" --execute="CREATE DATABASE IF NOT EXISTS $DATABASE_E2ETEST;"
mysql --password="$MYSQL_ROOT_PASSWORD" --execute="GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%';"
