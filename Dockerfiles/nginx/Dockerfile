# Basis-Image: Alpine mit NGINX
FROM nginx:alpine

# Kopiere die NGINX-Konfiguration
COPY conf/wordpress.conf etc/nginx/conf.d/default.conf

# Kopiere SSL-Zertifikate
# COPY conf/cert.pem /etc/ssl/certs/cert.pem
# COPY conf/key.pem /etc/ssl/private/key.pem

# Exponiere Port 443 für HTTPS
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
