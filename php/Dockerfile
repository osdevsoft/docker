FROM php:7.4-fpm

ARG TIMEZONE

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN printf '[PHP]\ndate.timezone = "Europe/Madrid"\n' > /usr/local/etc/php/conf.d/tzone.ini

# Setup php.ini
ADD conf/php.ini $PHP_INI_DIR/conf.d/php.ini

#database
RUN apt-get update
RUN docker-php-ext-install pdo pdo_mysql

#rabbitmq
RUN docker-php-ext-install sockets bcmath

#Filebeat (for Logstash)
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.7.0-amd64.deb \
    && dpkg -i filebeat-6.7.0-amd64.deb
COPY conf/filebeat.yml /etc/filebeat/filebeat.yml

#zip lib
RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip

#extra soft (ps)
RUN apt-get install -y procps systemd

#supervisor for Message Queues
RUN apt-get install -y supervisor
#CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

#xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=OSDSXDEBUGKEY" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \