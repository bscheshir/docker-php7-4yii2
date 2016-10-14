FROM php:7.0.11-fpm

MAINTAINER BSCheshir <bscheshir.work@gmail.com>

# libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev - for gd
# zlib1g-dev libicu-dev - for intl
# libpq-dev - for pdo_pgsql
# libmagickwand-dev - for imagick
# libz-dev libmemcached-dev - for memcached

RUN apt-get update \
        && buildDeps=" \
                git \
                libmemcached-dev \
                zlib1g-dev \
        " \
        && doNotUninstall=" \
                libmemcached11 \
                libmemcachedutil2 \
        " \
        && apt-get install -y $buildDeps --no-install-recommends \
        && rm -r /var/lib/apt/lists/* \
        \
        && docker-php-source extract \
        && git clone --branch php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached/ \
        && docker-php-ext-install memcached \
        \
        && docker-php-source delete \
        && apt-mark manual $doNotUninstall \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

RUN apt-get update && apt-get install -y \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        zlib1g-dev \
        libicu-dev \
        libpq-dev \
        libmagickwand-dev \
    && apt-get clean \
    && docker-php-ext-install -j$(nproc) pdo_mysql pdo_pgsql \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) intl gd \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && echo "expose_php = off\n\
cgi.fix_pathinfo = 0" >> /usr/local/etc/php/php.ini 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require "fxp/composer-asset-plugin:^1.2.0"

ENV XDEBUG_VERSION 2.4.1

RUN curl -fsSL "http://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz" -o xdebug-$XDEBUG_VERSION.tar.gz \
    && mkdir -p xdebug-$XDEBUG_VERSION \
    && tar -xf xdebug-$XDEBUG_VERSION.tar.gz -C xdebug-$XDEBUG_VERSION --strip-components=1 \
    && rm xdebug-$XDEBUG_VERSION.tar.gz \
    && ( \
        cd xdebug-$XDEBUG_VERSION \
        && phpize \
        && ./configure --enable-xdebug \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r xdebug-$XDEBUG_VERSION \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_port = 9001\n\
xdebug.idekey = \"PHPSTORM\"\n\
xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN rm -r /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
