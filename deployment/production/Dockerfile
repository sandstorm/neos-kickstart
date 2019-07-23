FROM sandstormmedia/neos-base

ADD --chown=www-data:www-data /app/. /app

ADD /deployment/production/entrypoint.sh /entrypoint.sh

ENV FLOW_CONTEXT 'Production/Kubernetes'

# you need root access to bind to ports below 1024 and we run
# nginx as www-data user so we use a higher port
ENV NGINX_PORT 8080
ENV NGINX_HOST '0.0.0.0'

ENTRYPOINT ["/entrypoint.sh"]
