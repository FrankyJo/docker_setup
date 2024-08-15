FROM php:8.2.1-fpm

# Устанавливаем необходимые расширения для MySQL
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Используем базовый образ на основе Ubuntu
FROM ubuntu:latest

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y libnss3-tools curl

# Скачиваем и устанавливаем mkcert
RUN curl -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 -o /usr/local/bin/mkcert && \
    chmod +x /usr/local/bin/mkcert

# Создаем директорию для хранения сертификатов
RUN mkdir -p /certs

# Устанавливаем рабочую директорию
WORKDIR /certs

# Генерация сертификатов при запуске контейнера
ENTRYPOINT ["mkcert"]

