#!/usr/bin/env bash

echo "Starting Import"

gzip -dk /app/ContentDump/Database.sql.gz

# generating tables to be dropped before restoring backup
echo "SET FOREIGN_KEY_CHECKS = 0;" > ./temp.sql
mysqldump \
    --host=maria-db \
    --user=neos \
    --password=neos \
    --add-drop-table \
    --no-data \
    neos \
     | grep 'DROP TABLE' >> ./temp.sql
echo "SET FOREIGN_KEY_CHECKS = 1;" >> ./temp.sql

# dropping tables
mysql --host=maria-db --user=neos --password=neos neos < ./temp.sql

# importing dumps
mysql --host=maria-db --user=neos --password=neos neos < /app/ContentDump/Database.sql

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
