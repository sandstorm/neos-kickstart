# NOTE: this file is executed from the ROOT DIRECTORY of the project, i.e. "../"
FROM php:7.2-cli

RUN apt-get update

# Install PDO pgsql PHP extension
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Install gd PHP extension
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Install various other PHP extensions
RUN docker-php-ext-install bcmath

# install Git
RUN apt-get install -y \
        --no-install-recommends git unzip

RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer config --global cache-dir /composer_cache
ADD local-dev/neos/entrypoint.sh /
ADD local-dev/neos/memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini

WORKDIR /app

EXPOSE 8081

ENTRYPOINT [ "/entrypoint.sh" ]

