FROM debian:bullseye

# Installiere MariaDB und andere notwendige Pakete
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && apt-get clean

# Erstelle notwendige Verzeichnisse und setze Berechtigungen
RUN mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Kopiere die MariaDB Konfigurationsdatei
COPY my.cnf /etc/mysql/my.cnf

# Exponiere den Standardport für MariaDB
EXPOSE 3306

# Kopiere das Startskript und setze Ausführungsrechte
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Setze das Startskript als Entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# Standardbefehl zum Starten von MariaDB
CMD ["mysqld"]