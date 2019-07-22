FROM sandstormmedia/neos-base:1.0

ADD --chown=www-data:www-data /app/. /app

ADD /deployment/production/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
