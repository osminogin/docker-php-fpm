# docker-php-fpm [![](https://images.microbadger.com/badges/image/osminogin/php-fpm.svg)](https://microbadger.com/images/osminogin/php-fpm)

Generic PHP-FPM container for your web apps. 

Just add your favorite frontend web server (nginx for me).

## Running

```bash
docker run --name webapp osminogin/php-fpm
```

**Warning**: Always link this container to web server directly and not expose 9000 port for security reasons.

## Getting started

Recommended to mount web application root inside container with same path (to avoid confusion).


```yaml
# docker-compose.yml
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

Corresponding server section of nginx.conf:

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
