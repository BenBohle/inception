FROM debian:bullseye

# Installiere NGINX und OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    gettext-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# SSL-Zertifikate generieren
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/${DOMAIN_NAME}-key.pem \
    -out /etc/nginx/ssl/${DOMAIN_NAME}-cert.pem -days 365 -nodes \
    -subj "/CN=${DOMAIN_NAME}"


# Entferne Standard-NGINX-Site und füge eigene hinzu
RUN rm -f /etc/nginx/sites-enabled/default
COPY conf/wordpress.conf.template /etc/nginx/
COPY conf/gcert.sh /usr/local/bin/gcert.sh

# Setze Berechtigungen für das Skript
RUN chmod +x /usr/local/bin/gcert.sh

# Exponiere Ports
EXPOSE 443

# Startet das Zertifikatsskript und NGINX
ENTRYPOINT [ "/usr/local/bin/gcert.sh" ]
