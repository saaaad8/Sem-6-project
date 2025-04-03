FROM php:7.3-alpine AS builder

# Install build dependencies and PHP extensions
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) pdo_mysql mbstring exif pcntl bcmath gd \
    && apk del --no-cache .build-deps

# Install runtime dependencies needed for extensions
RUN apk add --no-cache \
    libpng \
    libjpeg-turbo \
    freetype \
    oniguruma \
    libxml2

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy the entire application to have proper file structure for Composer
COPY . .

# Create required directories explicitly
RUN mkdir -p database/seeds database/factories app/Models

# Install production dependencies with --ignore-platform-reqs to bypass potential issues
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-progress --no-interaction --ignore-platform-reqs

# Final stage
FROM php:7.3-alpine

# Install runtime dependencies
RUN apk add --no-cache \
    libpng \
    libjpeg-turbo \
    freetype \
    oniguruma \
    libxml2

# Install required PHP extensions in the final image
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) pdo_mysql mbstring exif pcntl bcmath gd \
    && apk del --no-cache .build-deps

# Set working directory
WORKDIR /var/www/html

# Copy the entire application from the builder stage
COPY --from=builder /var/www/html /var/www/html

# Create required directories if they don't exist in the codebase
RUN mkdir -p database/seeds database/factories app/Models

# Set proper permissions
RUN chmod -R 777 storage bootstrap/cache

# Copy entrypoint and set permissions
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]