#!/bin/bash

# Перевіряємо наявність аргументу (ім'я піддомену)
if [ -z "$1" ]; then
    echo "Використання: $0 subdomain.localdevdomain.com"
    exit 1
fi

SUBDOMAIN=$1
CONFIG_DIR="./docker/nginx/conf.d"
CONFIG_FILE="$CONFIG_DIR/$SUBDOMAIN.conf"
CERT_DIR="/etc/nginx/ssl"
WEB_ROOT="/var/www/html/$SUBDOMAIN"

# Створення конфігураційного файлу Nginx
sudo mkdir -p $CONFIG_DIR

cat > $CONFIG_FILE <<NGINX_CONF
server {
    listen 443 ssl;
    server_name $SUBDOMAIN;

    ssl_certificate $CERT_DIR/cert.pem;
    ssl_certificate_key $CERT_DIR/key.pem;

    root $WEB_ROOT;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass php:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}

server {
    listen 80;
    server_name $SUBDOMAIN;
    return 301 https://\$host\$request_uri;
}
NGINX_CONF

echo "Конфігураційний файл Nginx створено: $CONFIG_FILE"

# Створення веб-кореневої директорії для піддомену
sudo mkdir -p $WEB_ROOT

echo "Веб-коренева директорія створена: $WEB_ROOT"

sudo chmod -R 777 $WEB_ROOT

# Перезапуск Nginx для застосування нових налаштувань
sudo docker compose restart nginx

echo "Nginx перезапущено"

