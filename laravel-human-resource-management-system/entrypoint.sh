#!/bin/sh

php artisan key:generate

php artisan migrate --seed

# Start the application
exec "$@"