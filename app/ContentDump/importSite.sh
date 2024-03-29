#!/usr/bin/env bash

IMPORT_FILE=/app/ContentDump/Database.sql.gz

if [ -f "$IMPORT_FILE" ];
    then
        echo "Starting Import"
    else
        echo "No import file found: Exiting"
        exit 0
fi

gzip -dk ${IMPORT_FILE}

echo "Importing content"

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
RESOURCES_FILE=/app/ContentDump/Resources.tar.gz

if [ -f "$RESOURCES_FILE" ];
    then
        echo "Importing resouces"
        tar -xf ${RESOURCES_FILE} -C /app/Data/Persistent/Resources

        # publishing resources and warming up
        ./flow resource:publish
    else
        echo "No resources file found: skipping"
fi

./flow user:create --roles Administrator admin password LocalDev Admin || true

echo "ALL DONE, HAVE FUN ;)"
echo "(you have to re-create the neos users)"
