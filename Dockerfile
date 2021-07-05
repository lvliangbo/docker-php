FROM php:7.4-fpm

#timezone
RUN echo "Asia/Shanghai" > /etc/timezone

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
        libicu-dev \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        libzip-dev

#php extension
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    gettext \
    intl \
    mysqli \
    pcntl \
    shmop \
    soap \
    sockets \
    sysvsem \
    tokenizer \
    xmlrpc \
    xsl \
    zip

#php extension mcrypt
RUN apt-get install -y --no-install-recommends libmcrypt-dev \
    && pecl install mcrypt-1.0.4 \
    && docker-php-ext-enable mcrypt

#php extension redis
RUN pecl install redis-5.3.4 \
    && docker-php-ext-enable redis

#php extension xdebug
RUN pecl install xdebug-3.0.4 \
    && docker-php-ext-enable xdebug

#php extension memcached
RUN apt-get install -y --no-install-recommends libmemcached-dev \
    && pecl install memcached-3.1.5 \
    && docker-php-ext-enable memcached

#php extension mongodb
RUN pecl install mongodb-1.9.1 \
    && docker-php-ext-enable mongodb

#php extension rdkafka
RUN apt-get install -y --no-install-recommends librdkafka-dev \
    && pecl install rdkafka-5.0.0 \
    && docker-php-ext-enable rdkafka

#php extension gd
RUN apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-install -j$(nproc) gd

#php extension opcache
RUN docker-php-ext-enable opcache

RUN rm -r /var/lib/apt/lists/*

CMD ["php-fpm"]
EXPOSE 9000