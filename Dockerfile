# Use official PHP image with extensions
FROM laravelphp/php-fpm-nginx:8.2

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y     git     curl     zip     unzip     libzip-dev     libpq-dev     && docker-php-ext-install zip pdo pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Build assets
RUN npm install && npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port
EXPOSE 80

# Start Laravel
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=80