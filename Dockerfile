FROM php:8.2-apache

#instalar extensiones de php necesarias
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN a2enmod rewrite

#configurar el DocumentRoot
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

#configurar permisos
RUN chown -R www-data:www-data /var/www/html

#exponer el puerto 80
EXPOSE 80

#iniciar apache
CMD ["apache2-foreground"]