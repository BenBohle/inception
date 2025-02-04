#!/bin/bash
set -e

# Überprüfen, ob die notwendigen Umgebungsvariablen gesetzt sind
if [[ -z "${DOMAIN_NAME}" ]]; then
  echo "Fehler: DOMAIN_NAME ist nicht gesetzt!"
  exit 1
fi

# Falls Zertifikate nicht existieren, neu erstellen
if [[ ! -f "/etc/nginx/ssl/${DOMAIN_NAME}-cert.pem" ]]; then
    echo "Erstelle selbstsigniertes Zertifikat für ${DOMAIN_NAME}"
    openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/${DOMAIN_NAME}-key.pem \
        -out /etc/nginx/ssl/${DOMAIN_NAME}-cert.pem -days 365 -nodes \
        -subj "/CN=${DOMAIN_NAME}"
fi

# Ersetze DOMAIN_NAME in der NGINX-Config
envsubst '${DOMAIN_NAME}' < /etc/nginx/wordpress.conf.template > /etc/nginx/conf.d/wordpress.conf

echo "Nutze selbstsigniertes SSL-Zertifikat für ${DOMAIN_NAME}"

# Starte NGINX
exec nginx -g "daemon off;"
