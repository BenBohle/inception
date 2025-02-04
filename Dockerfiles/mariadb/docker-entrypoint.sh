#!/bin/bash
set -e

# Überprüfen, ob notwendige Umgebungsvariablen gesetzt sind
if [[ -z "${WP_DB_NAME}" || -z "${WP_DB_USER}" || -z "${WP_DB_PASSWORD}" ]]; then
  echo "Fehler: WP_DB_NAME, WP_DB_USER oder WP_DB_PASSWORD sind nicht gesetzt!"
  exit 1
fi

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
    CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';
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
