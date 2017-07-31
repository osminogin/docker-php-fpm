# docker-php-fpm

[![](https://img.shields.io/docker/build/osminogin/php-fpm.svg)](https://hub.docker.com/r/osminogin/php-fpm/builds/) [![](https://img.shields.io/docker/stars/osminogin/php-fpm.svg)](https://hub.docker.com/r/osminogin/php-fpm) [![](https://images.microbadger.com/badges/image/osminogin/php-fpm.svg)](https://microbadger.com/images/osminogin/php-fpm) [![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

**Secure minimal PHP-FPM container for your web apps.**

Just link with your favorite frontend web server and you ready for production use.

:star2: Star this project on Docker Hub: https://hub.docker.com/r/osminogin/php-fpm/ :star2:

## Running

```bash
docker run --name webapp -v /var/www:/var/www:ro osminogin/php-fpm
```
Recommended to mount web application root inside container with same path (to avoid confusion).

**Warning**: Always link this container to web server directly and not expose 9000 port for security reasons.

## Unit file for systemd

#### php-fpm.service:
```ini
[Unit]
Description=FluxBB service
After=docker.service mariadb.service nginx.service
Requires=docker.service
Wants=mariadb.service nginx.service

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=35s
ExecStartPre=/usr/bin/docker pull osminogin/php-fpm
ExecStart=/usr/bin/docker run --rm --name webapp --link nginx:nginx --link mariadb:mysqlhost -v /var/www:/var/www:ro osminogin/php-fpm
ExecStop=/usr/bin/docker stop webapp

[Install]
WantedBy=multi-user.etarget
```


## Examples

Example php webapp deployment config in cooperation with official Nginx and MariaDB containers.

#### docker-compose.yml

```yaml
version: '2'
services:
  webapp:
    image: osminogin/php-fpm
    container_name: webapp
    volumes:
      - /srv/webroot:/srv/webroot
    links:
      - mysql
  nginx:
    image: nginx
    ports:
      - "80:80"
      - "443:443"
    links:
      - webapp
    volumes:
      - /srv/nginx.conf:/etc/nginx/nginx.conf:ro
    volumes_from:
      - webapp:ro
  mysql:
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: changeme
```

Corresponding server section of ``nginx.conf``:

```
server {
    listen 80;
    root /srv/webroot;

    location / { rewrite ^ /index.php; }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_pass webapp:9000;
    }
}
```

## License

MIT
