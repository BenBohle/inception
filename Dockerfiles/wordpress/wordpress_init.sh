#!/bin/bash
set -e
# set -x

# echo "Starte WordPress-Setup..."

# Warte, bis MySQL-Port erreichbar ist
until nc -z "${WORDPRESS_DB_HOST}" 3306; do
  echo "Warte auf den MySQL-Port 3306..."
  sleep 3
done

# echo "Datenbank ist bereit!"

if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Erstelle wp-config.php..."
  wp config create --dbname="wordpress_db" --dbuser="myuser" --dbpass="mysecretpassword" --dbhost="mariadb" --allow-root


# WordPress installieren, falls es noch nicht installiert ist
  echo "Installiere WordPress..."
  wp core install --url="${DOMAIN_NAME}" --title="WordPress" \
    --admin_user="${WORDPRESS_ADMIN_USER}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" --skip-email --allow-root

# Setze Permalinks
wp rewrite structure '/%postname%/' --allow-root

# Installiere und aktiviere Standard-Theme & Plugins
wp theme install twentytwentyone --activate --allow-root
# wp plugin install --activate --allow-root

echo "WordPress-Installation abgeschlossen."
fi

php-fpm7.4 -F