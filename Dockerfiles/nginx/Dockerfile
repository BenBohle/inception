FROM debian:bullseye

# Installiere NGINX und andere notwendige Pakete
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean

# Kopiere die NGINX-Konfiguration
RUN rm /etc/nginx/sites-enabled/default
COPY conf/wordpress.conf /etc/nginx/conf.d/

# Kopiere SSL-Zertifikate (optional)
# COPY conf/cert.pem /etc/ssl/certs/cert.pem
# COPY conf/key.pem /etc/ssl/private/key.pem

# Exponiere den Standardport für NGINX
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]