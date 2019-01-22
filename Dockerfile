#
# PHP-CLI 7 Dockerfile
#

# Pull base image
FROM php:7.3-fpm-alpine

ARG PHALCON_VERSION

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
    && curl -sS -o /tmp/phalcon.tar.gz https://codeload.github.com/phalcon/cphalcon/tar.gz/v$PHALCON_VERSION \
    && cd /tmp/ \
    && tar xvzf phalcon.tar.gz \
    && cd cphalcon-$PHALCON_VERSION/build \
    && sh install \
    && pecl install yaml \
    && pecl install redis \
    && pecl install xdebug-2.7.0beta1 \
    && docker-php-ext-enable yaml redis xdebug \
    && apk del build-dependencies \
    && rm -rf cphalcon-$PHALCON_VERSION \
        v$PHALCON_VERSION \
        /var/cache/apk/* \
        /tmp/* \
        /var/tmp/* \
    && unset PHALCON_VERSION

RUN curl -LsS https://codeception.com/codecept.phar -o /usr/local/bin/codecept
RUN chmod a+x /usr/local/bin/codecept

WORKDIR /project
