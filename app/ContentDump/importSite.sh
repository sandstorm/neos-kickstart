#!/usr/bin/env bash

echo "Starting Import"

gzip -dk /app/ContentDump/Database.sql.gz

# generating tables to be dropped before restoring backup
echo "SET FOREIGN_KEY_CHECKS = 0;" > ./temp.sql
mysqldump \
    --host=$DB_NEOS_HOST \
    --user=$DB_NEOS_USER \
    --password=$DB_NEOS_PASSWORD \
    --add-drop-table \
    --no-data \
    $DB_NEOS_DATABASE \
     | grep 'DROP TABLE' >> ./temp.sql
echo "SET FOREIGN_KEY_CHECKS = 1;" >> ./temp.sql

# dropping tables
mysql --host=$DB_NEOS_HOST --user=$DB_NEOS_USER --password=$DB_NEOS_PASSWORD $DB_NEOS_DATABASE < ./temp.sql

# importing dumps
mysql --host=$DB_NEOS_HOST --user=$DB_NEOS_USER --password=$DB_NEOS_PASSWORD $DB_NEOS_DATABASE < /app/ContentDump/Database.sql

# cleaning up
rm ./temp.sql
rm /app/ContentDump/Database.sql

# Removing Resources
rm -rf /app/Data/Persistent/Resources/*

# Unzipping into Resources
tar -xf /app/ContentDump/Resources.tar.gz -C /app/Data/Persistent/Resources

# publishing resources and warming up
./flow resource:publish

echo "ALL DONE, HAVE FUN ;)"
echo "(you have to re-create the neos users)"
