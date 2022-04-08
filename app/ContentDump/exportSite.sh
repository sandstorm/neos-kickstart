#!/usr/bin/env bash

# IMPORTANT: will run in Container
echo "Starting Export In Container"

tar fcz /app/ContentDump/Resources.tar.gz -C /app/Data/Persistent/Resources/ .
mysqldump --host=maria-db --user=neos --password=neos neos | gzip > /app/ContentDump/Database.sql.gz
