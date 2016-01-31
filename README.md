# docker-php-fpm

Generic PHP-FPM container for your web apps. Just add frontend web server.

Please star this project on Docker Hub: https://hub.docker.com/r/osminogin/php-fpm/

## Getting started

```bash
docker run --name php-fpm osminogin/php-fpm
```

## Example

```yaml
# docker-compose.yml
drupal:
  image: osminogin/php-fpm
  volumes:
    - /srv/drupal:/srv/www
  links:
    - mysql

nginx:
  image: nginx
  ports:
    - "80:80"
    - "443:443"
  links:
    - drupal
  volumes_from:
    - drupal

mysql:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: changeme
```

## License

MIT
