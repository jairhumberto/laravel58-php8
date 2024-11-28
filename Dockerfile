FROM php:7.3-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git zip unzip libzip-dev libonig-dev libssl-dev && \
    docker-php-ext-install pdo pdo_mysql mbstring zip

# Configure PHP memory limit
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /app

# Install project dependencies
COPY composer.json ./
RUN composer update --no-scripts --no-autoloader

# Copy project code
COPY . .

# Dump autoload
RUN composer dump-autoload

# Run PHPUnit
CMD ["vendor/bin/phpunit"]
