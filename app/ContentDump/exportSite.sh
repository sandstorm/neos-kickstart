#!/usr/bin/env bash

# IMPORTANT: will run in Container
echo "Starting Export In Container"

tar fcz /app/ContentDump/Resources.tar.gz -C /app/Data/Persistent/Resources/ .

mysqldump \
    --host=$DB_NEOS_HOST \
    --user=$DB_NEOS_USER \
    --password=$DB_NEOS_PASSWORD \
    --no-data \
    $DB_NEOS_DATABASE \
     > ./temp.sql

mysqldump \
    --host=$DB_NEOS_HOST \
    --user=$DB_NEOS_USER \
    --password=$DB_NEOS_PASSWORD \
    $DB_NEOS_DATABASE \
    --no-create-info \
    --ignore-table=neos.neos_contentrepository_domain_model_workspace \
    --ignore-table=neos.neos_contentrepository_domain_model_nodedata \
    --ignore-table=neos.neos_flow_security_account \
    --ignore-table=neos.neos_neos_domain_model_user \
    --ignore-table=neos.neos_neos_domain_model_userpreferences \
    --ignore-table=neos.neos_party_domain_model_abstractparty_accounts_join \
    --ignore-table=neos.neos_party_domain_model_abstractparty \
    --ignore-table=neos.neos_party_domain_model_electronicaddress \
    --ignore-table=neos.neos_party_domain_model_person \
    --ignore-table=neos.neos_party_domain_model_person_electronicaddresses_join \
    --ignore-table=neos.neos_party_domain_model_personname \
     >> ./temp.sql

mysqldump \
    --host=$DB_NEOS_HOST \
    --user=$DB_NEOS_USER \
    --password=$DB_NEOS_PASSWORD \
    $DB_NEOS_DATABASE \
    --no-create-info \
    --tables neos_contentrepository_domain_model_workspace --where="name = 'live'" \
     >> ./temp.sql

mysqldump \
    --host=$DB_NEOS_HOST \
    --user=$DB_NEOS_USER \
    --password=$DB_NEOS_PASSWORD \
    $DB_NEOS_DATABASE \
    --no-create-info \
    --tables neos_contentrepository_domain_model_nodedata --where="workspace = 'live'" \
     >> ./temp.sql

gzip ./temp.sql
mv ./temp.sql.gz /app/ContentDump/Database.sql.gz
