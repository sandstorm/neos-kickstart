# NOTE: this file is executed from the ROOT DIRECTORY of the project, i.e. "../"
FROM php:8.0-fpm-buster

###################### START - Dev Container only ######################
# IMPORTANT: we try to keep the production and local-dev the same      #
# all local dev related changes should stay within this block. Also    #
# consider making a diff with `production/Dockerfile` and copying over #
# the latest changes to keep both containers in sync                   #
########################################################################

# install git and unzip for Composer
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y unzip git default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

# HOTFIX for ARM64 Architectures and VIPS (see https://github.com/opencv/opencv/issues/14884#issuecomment-706725583 for details)
ADD deployment/config-files/bash.vips-arm64-hotfix.sh /etc/bash.vips-arm64-hotfix.sh
RUN echo '. /etc/bash.vips-arm64-hotfix.sh' >>  /etc/bash.bashrc

####################### END - Dev Container only ########################

# Install intl, bcmath, pdo, pdo_mysql, mysqli, libvips
# debug tools: vim, inotify-tools
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        libicu-dev \
        libxslt1-dev \
        nginx-light \
        libvips42 \
        libvips-dev \
        supervisor \
        procps \
        libpq-dev \
        vim \
        inotify-tools \
        && \
    mkdir -p /var/log/supervisor && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install intl bcmath pdo pdo_mysql xsl && \
    pecl install vips && \
    echo "extension=vips.so" > /usr/local/etc/php/conf.d/vips.ini && \
    pecl install redis && docker-php-ext-enable redis

# install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer config --global cache-dir /composer_cache

# add colored shell env to distinguish environments properly
ENV SHELL_ENV_DISPLAY=dev
ADD deployment/config-files/bash.colorprompt.sh /etc/bash.colorprompt.sh
RUN echo '. /etc/bash.colorprompt.sh' >>  /etc/bash.bashrc

# Installing Supercronic
# We use this to only run a cronjob if the prvious has finished
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e
RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# application entrypoint
ADD /deployment/local-dev/neos/entrypoint.sh /
ADD /deployment/config-files/memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini
ADD /deployment/config-files/upload-limit-php.ini /usr/local/etc/php/conf.d/upload-limit-php.ini

RUN rm -Rf /usr/local/etc/php-fpm.* && rm -Rf /etc/nginx/conf.d/*
ADD deployment/config-files/php-fpm.conf /usr/local/etc/php-fpm.conf

ADD /deployment/config-files/nginx.conf /deployment/config-files/nginx-e2etest-server-dev.conf /etc/nginx/

RUN mkdir -p /var/lib/nginx /usr/local/var/log/ && \
    chown -R www-data /var/lib/nginx /usr/local/var/log/ /etc/nginx/ &&\
    ln -s /etc/nginx/nginx-e2etest-server-dev.conf /etc/nginx/conf.d/nginx-e2etest-server-dev.conf

# cleanup & chown
RUN mkdir -p /app/Data/Persistent /app/Configuration/Development/Docker /app/Build/Behat /composer_cache && \
    chown -R www-data /app /composer_cache && \
    apt-get clean

# utility scripts
ADD deployment/utilities/watchAndLogExceptions.sh /app/watchAndLogExceptions.sh
RUN chmod +x /app/watchAndLogExceptions.sh

WORKDIR /app

USER www-data
ENTRYPOINT [ "/entrypoint.sh" ]
