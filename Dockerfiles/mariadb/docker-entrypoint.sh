#!/bin/bash
set -e

service mariadb start

mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME};"
mysql -u root -e "CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"

service mariadb stop

# Starte den MariaDB-Dienst im Vordergrund
exec "$@"