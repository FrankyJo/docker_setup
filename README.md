Докер конфіг щоб можна було швидко розгорнути собі простір для роботи 

На данний час є: Php, Nginx, MySql

Як розгорнути сайт

1. Скачать репозиторій
2. docker build -t mkcert-generator .
3. docker run --rm -v $(pwd)/docker/nginx/ssl:/certs mkcert-generator -install -cert-file /docker/nginx/ssl/cert.pem -key-file /docker/nginx/ssl/key.pem "*.localdevdomain.com"
4. sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /{YOR_VOLUMES}/docker-dev/docker/nginx/ssl/cert.pem

Ця команда додає сертифікат в перевірені
Тож треба піти в місце де лежать перевірені сертифікати і переконатись що там стоіть "Довіряти"

https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/#installing-root-cert 

5. ./generate-nginx-config.sh subdomain.localdevdomain.com
5. далі в терміналі  sudo nano /etc/hosts і там додаємо 127.0.0.1 subdomen.localdevdomain.com (або згідно того як ви назвали свій основний локальний домен)
6. docker compose build
7. docker compose up -d

Все, теперь ви можете працювати з ПХП

Перезавантижити

1. docker compose down
2. docker compose up -d

Якщо хочете розгонути локально ще один сайт

1. ./generate-nginx-config.sh subdomain2.localdevdomain.com
2. Далі sudo nano /etc/hosts і там додаємо 127.0.0.1 subdomen2.localdevdomain.com
3. docker compose down
4. docker compose up -d

Для підключення дл бази данних:
хост: mysql
user: root
pass: root