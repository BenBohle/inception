FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    tar \
    wget \
    netcat-traditional \
    default-mysql-client \
    && apt-get clean

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create the necessary directories
RUN mkdir -p /var/www/html /run/php /var/log/php-fpm

# Download and extract WordPress
RUN curl -o /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xvzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 \
    && chown -R www-data:www-data /var/www/html \
    && rm /tmp/latest.tar.gz

# Copy PHP configuration
COPY conf/php.ini /etc/php/7.4/fpm/php.ini
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/.

# Copy the setup script
COPY wordpress_init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress_init.sh

WORKDIR /var/www/html

# Expose port 9000 for PHP-FPM
EXPOSE 9000

RUN chown -R www-data:www-data /var/www/html

ENTRYPOINT [ "bash", "wordpress_init.sh" ]

# Start PHP-FPM and run the setup script
    # CMD ["sh", "-c", "php-fpm7.4 -F -R"]