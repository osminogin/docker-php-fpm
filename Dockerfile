FROM debian:latest
MAINTAINER Vladimir Osintsev <oc@co.ru>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install \
	php5 \
	php-pear \
	php5-gd \
	php5-sqlite \
	php5-pgsql \
	php5-mysql \
	php5-mcrypt \
	php5-xcache \
	php5-xmlrpc \
	php5-fpm

RUN sed -i '/^listen /c listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf

RUN mkdir -p /srv/www && \
    echo "<?php phpinfo(); ?>" > /srv/www/index.php && \
    chown -R www-data:www-data /srv/www

EXPOSE 9000
VOLUME /srv/www

CMD php5-fpm --nodaemonize 
