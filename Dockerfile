FROM debian:latest
MAINTAINER Vladimir Osintsev <oc@co.ru>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install --no-install-recommends \
	ca-certificates \
	php5 \
	php-pear \
	php5-gd \
	php5-sqlite \
	php5-pgsql \
	php5-mysql \
	php5-mcrypt \
	php5-xcache \
	php5-xmlrpc \
	php5-fpm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -ri \
		-e '/^listen /c listen = 0.0.0.0:9000' \
		-e '/^;catch_workers_output /s/^;//' \
		/etc/php5/fpm/pool.d/www.conf && \
    mkdir -p /srv/www && \
    echo "<?php phpinfo(); ?>" > /srv/www/index.php && \
    chown -R www-data:www-data /srv/www && \
    ln -sf /dev/stdout /var/log/php5-fpm.log 

EXPOSE 9000
VOLUME /srv/www

CMD ["php5-fpm", "--nodaemonize"]
