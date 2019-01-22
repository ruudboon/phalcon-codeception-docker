#
# PHP-CLI 7 Dockerfile
#

# Pull base image
FROM php:7.3-fpm-alpine

MAINTAINER Ruud Boon <ruud@ruudboon.io>

RUN docker-php-ext-install pdo_mysql
RUN apk --update add bash yaml-dev fcgi composer

RUN \
    apk add --virtual build-dependencies \
        autoconf \
        g++ \
        pcre-dev \
        file \
        re2c \
        make \  
    && pecl install psr \  
    && docker-php-ext-enable psr \ 
    && curl -sS -o /tmp/phalcon.tar.gz https://codeload.github.com/phalcon/cphalcon/tar.gz/v4.0.0-alpha1 \
    && cd /tmp/ \
    && tar xvzf phalcon.tar.gz \
    && cd cphalcon-4.0.0-alpha1/build \
    && sh install \
    && pecl install yaml \
    && pecl install redis \
    && pecl install xdebug-2.7.0beta1 \
    && docker-php-ext-enable yaml redis xdebug \
    && docker-php-ext-enable phalcon --ini-name z-docker-php-ext-phalcon.ini \
    && apk del build-dependencies \
    && rm -rf cphalcon-4.0.0-alpha1 \
        v4.0.0-alpha1 \
        /var/cache/apk/* \
        /tmp/* \
        /var/tmp/*

RUN curl -LsS https://codeception.com/codecept.phar -o /usr/local/bin/codecept
RUN chmod a+x /usr/local/bin/codecept

WORKDIR /project
