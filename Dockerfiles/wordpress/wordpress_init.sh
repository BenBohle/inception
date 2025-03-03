#!/bin/bash
set -e
# set -x

# echo "Starte WordPress-Setup..."

# Warte, bis MySQL-Port erreichbar ist
until nc -z "${WORDPRESS_DB_HOST}" 3306; do
  echo "Warte auf den MySQL-Port 3306..."
  sleep 3
done

export WORDPRESS_DB_USER=$(cat /run/secrets/wp_db_user)
export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/wp_db_password)
export WORDPRESS_ADMIN_USER=$(cat /run/secrets/wp_admin)
export WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export WORDPRESS_ADMIN_EMAIL=$(cat /run/secrets/wp_admin_email)
export WORDPRESS_USER=$(cat /run/secrets/wp_user)
export WORDPRESS_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
export WORDPRESS_USER_EMAIL=$(cat /run/secrets/wp_user_email)
# echo "Datenbank ist bereit!"

if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Erstelle wp-config.php..."
  wp config create --dbname="${WORDPRESS_DB_NAME}" --dbuser="${WORDPRESS_DB_USER}" --dbpass="${WORDPRESS_DB_PASSWORD}" --dbhost="${WP_DB_HOST}" --allow-root


# WordPress installieren, falls es noch nicht installiert ist
  echo "Installiere WordPress..."
  wp core install --url="https://${DOMAIN_NAME}" --title="WordPress" \
    --admin_user="${WORDPRESS_ADMIN_USER}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" --skip-email --allow-root

# Setze WordPress-URL und Website-URL auf HTTPS
wp option update home "https://${DOMAIN_NAME}" --allow-root
wp option update siteurl "https://${DOMAIN_NAME}" --allow-root

# Setze Permalinks
wp rewrite structure '/%postname%/' --allow-root

echo "Erstelle normalen Benutzer..."
wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" --user_pass="${WORDPRESS_USER_PASSWORD}" --role=contributor --allow-root
echo "Normaler Benutzer erstellt."

echo "WordPress-Installation abgeschlossen."
fi

php-fpm7.4 -F