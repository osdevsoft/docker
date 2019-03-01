FROM php:7-fpm

ARG TIMEZONE

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN printf '[PHP]\ndate.timezone = "Europe/Madrid"\n' > /usr/local/etc/php/conf.d/tzone.ini

# Setup php.ini
#ADD php.ini $PHP_INI_DIR/conf.d/php.ini

RUN apt-get update
RUN docker-php-ext-install pdo pdo_mysql
