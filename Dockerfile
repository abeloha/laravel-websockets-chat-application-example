FROM php:8.1 as php

RUN apt-get update -y
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev libhiredis-dev
RUN docker-php-ext-install pdo pdo_mysql bcmath

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

WORKDIR /var/www
COPY . .

COPY --from=composer:2.1.8 /usr/bin/composer /usr/local/bin/composer

#referenced in the entry point
ENV PORT=8000
ENTRYPOINT [ "docker/entrypoint.sh" ]
