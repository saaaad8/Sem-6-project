FROM php:7.3-cli

# Install dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip \
 && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer 
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# #install Node.js v18
# RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
#     apt-get install -y nodejs

# Set working directory
WORKDIR /var/www/html

# Copy your project files to the container
COPY . /var/www/html

# Install composer dependencies
RUN composer update && composer install

# # Install npm dependencies
# RUN npm install && npm run dev

#Copy entrypoint.sh
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 8000 and start application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
