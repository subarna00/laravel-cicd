# composer dependencies
FROM composer AS composer-build

WORKDIR /var/www/html

COPY composer.json composer.lock /var/www/html/

RUN mkdir -p /var/www/html/database/{factories,seeders} \
    && composer install --no-dev --prefer-dist --no-scripts --no-autoloader --no-progress --ignore-platform-reqs


# npm dependencies
# FROM node:21-alpine AS npm-build

# WORKDIR /var/www/html

# COPY package.json package-lock.json vite.config.js /var/www/html/

# COPY resources  /var/www/html/resources

# COPY public /var/www/html/public

# RUN npm install && npm run build


# php image and dependencies
FROM php:8.2.0-fpm as php

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip libzip-dev \
    && docker-php-ext-install zip opcache pdo pdo_mysql

# override with custom php.ini settings


# override with custom opcache settings
# COPY docker/php/opcache.ini $PHP_INI_DIR/conf.d/

COPY --from=composer  /usr/bin/composer /usr/bin/composer

COPY --chown=www-data --from=composer-build /var/www/html/vendor /var/www/html/vendor
# COPY --chown=www-data --from=npm-build /var/www/html/public /var/www/html/public
COPY --chown=www-data . /var/www/html/
COPY --chown=www-data . /var/www/html/storage

RUN usermod --uid 1000 www-data
RUN groupmod --gid 1000  www-data
