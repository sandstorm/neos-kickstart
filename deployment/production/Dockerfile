# NOTE: this file is executed from the ROOT DIRECTORY of the project, i.e. "../"
FROM php:7.1-fpm-stretch

RUN apt-get update

# Install PDO mysql PHP extension
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Install gd PHP extension
RUN apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git unzip \
        nginx-light gettext-base \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath

# install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer config --global cache-dir /composer_cache

# application entrypoint
ADD /deployment/production/entrypoint.sh /
ADD /deployment/config-files/memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini
RUN rm -Rf /usr/local/etc/php-fpm.*
ADD deployment/config-files/php-fpm.conf /usr/local/etc/php-fpm.conf

# install nginx
RUN apt-get install -y nginx-light gettext-base

ADD /deployment/config-files/nginx.template.conf /etc/nginx/nginx.template
RUN mkdir -p /var/lib/nginx /usr/local/var/log/ & \
    chown -R www-data /var/lib/nginx /usr/local/var/log/ /etc/nginx/

# cleanup & chown
RUN mkdir -p /app/Data/Persistent /app/Configuration/Development/Docker /composer_cache && \
    chown -R www-data /app /composer_cache && \
    apt-get clean

ADD /app/. /app/

WORKDIR /app
USER www-data

ENTRYPOINT [ "/entrypoint.sh" ]
