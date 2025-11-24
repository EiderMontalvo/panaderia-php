FROM php:8.2-apache
#instalar extenciones necesarias de php
RUN docker-php-ext-install mysqli pdo pdo_mysql
#copiar el codigo php al contenedor
COPY ./www /var/www/html
