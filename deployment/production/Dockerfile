# NOTE: this file is executed from the ROOT DIRECTORY of the project, i.e. "../"
FROM php:7.4.0-fpm-buster

# Install intl, bcmath, pdo, pdo_mysql, mysqli, libvips
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y libicu-dev libxslt1-dev nginx-light libvips42 libvips-dev supervisor procps && \
    mkdir -p /var/log/supervisor && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install intl bcmath pdo pdo_mysql mysqli xsl && \
    pecl install vips && \
    echo "extension=vips.so" > /usr/local/etc/php/conf.d/vips.ini && \
    pecl install redis && docker-php-ext-enable redis

# install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer config --global cache-dir /composer_cache

# application entrypoint
ADD /deployment/production/entrypoint.sh /
ADD /deployment/config-files/memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini
ADD /deployment/config-files/upload-limit-php.ini /usr/local/etc/php/conf.d/upload-limit-php.ini

RUN rm -Rf /usr/local/etc/php-fpm.*
ADD deployment/config-files/php-fpm.conf /usr/local/etc/php-fpm.conf

ADD /deployment/config-files/nginx.template.conf /etc/nginx/nginx.template
RUN mkdir -p /var/lib/nginx /usr/local/var/log/ & \
    chown -R www-data /var/lib/nginx /usr/local/var/log/ /etc/nginx/

# cleanup & chown
RUN mkdir -p /app/Data/Persistent /app/Configuration/Development/Docker /composer_cache && \
    chown -R www-data /app /composer_cache && \
    apt-get clean

# add the App files as www-data. For high security environments, you would try remove permissions from the app files.
ADD --chown=www-data:www-data /app/. /app/
WORKDIR /app
USER www-data

ENTRYPOINT [ "/entrypoint.sh" ]
