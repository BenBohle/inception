# Verwende ein minimales Basis-Image
FROM alpine:latest

# Setze Umgebungsvariablen für MariaDB
ENV MARIADB_VERSION=11.6.2
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# Installiere MariaDB und andere notwendige Pakete
RUN apk update && apk add --no-cache mariadb mariadb-client

# Erstelle notwendige Verzeichnisse und setze Berechtigungen
RUN mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Kopiere die MariaDB Konfigurationsdatei
COPY my.cnf /etc/my.cnf

# Initialisiere die MariaDB Datenbank
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Exponiere den Standardport für MariaDB
EXPOSE 3306

# Kopiere das Startskript und setze Ausführungsrechte
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Setze das Startskript als Entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# Standardbefehl zum Starten von MariaDB
CMD ["mysqld"]