#!/bin/bash
set -e



export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_USER=$(cat /run/secrets/wp_db_user)
export MYSQL_PASSWORD=$(cat /run/secrets/wp_db_password)

# Überprüfen, ob notwendige Umgebungsvariablen gesetzt sind
if [[ -z "${WP_DB_NAME}" ]]; then
  echo "Fehler: WP_DB_NAME ist nicht gesetzt!"
  exit 1
fi

if [[ -z "${MYSQL_USER}" ]]; then
  echo "user: " ${MYSQL_USER}
  echo "user: " $MYSQL_USER
  echo "Fehler: MYSQL_USER ist nicht gesetzt!"
  exit 1
fi

if [[ -z "${MYSQL_PASSWORD}" ]]; then
  echo ${MYSQL_PASSWORD}
  echo "Fehler: MYSQL_PASSWORD istd nicht gesetzt!"
  exit 1
fi



echo ${WP_DB_NAME}
echo "user: " ${MYSQL_USER}
echo "user: " $MYSQL_USER

# MariaDB Datenverzeichnis initialisieren, falls es nicht existiert
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisiere MariaDB Datenverzeichnis..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Starte MariaDB im Hintergrund
echo "Starte MariaDB..."
mysqld --skip-networking --socket=/var/run/mysqld/mysqld.sock &
pid="$!"

# Warten, bis MariaDB bereit ist
echo "Warte auf MariaDB..."
for i in {30..0}; do
    if mysqladmin ping &>/dev/null; then
        break
    fi
    echo "MariaDB nicht bereit, warte..."
    sleep 1
done

if [ "$i" = 0 ]; then
    echo "Fehler: MariaDB konnte nicht gestartet werden."
    exit 1
fi

# Datenbank und Benutzer erstellen, falls sie nicht existieren
echo "Erstelle Datenbank und Benutzer..."
mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;

EOSQL

# Wartezeit, um sicherzustellen, dass Änderungen übernommen wurden
sleep 3

# Beende Hintergrundprozess von MariaDB
kill "$pid"
wait "$pid"

# Starte MariaDB im Vordergrund
echo "Starte MariaDB im Vordergrund..."
exec mysqld
