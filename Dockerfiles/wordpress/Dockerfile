FROM php:7.4-fpm-alpine

# Installiere bash und curl
RUN apk add --no-cache bash curl

# Lade und entpacke WordPress
RUN curl -o /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xvzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 \
    && chown -R www-data:www-data /var/www/html \
    && rm /tmp/latest.tar.gz

# Setze Arbeitsverzeichnis
WORKDIR /var/www/html

# Kopiere PHP-Konfiguration
COPY conf/php.ini /usr/local/etc/php/

# Exponiere Port 9000 (PHP-FPM)
EXPOSE 9000

# Starte PHP-FPM
CMD ["php-fpm"]