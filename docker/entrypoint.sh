#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
    case "$APP_ENV" in
    "local")
        echo "Copying .env.example ... "
        cp .env.example .env
    ;;
    "prod")
        echo "Copying .env.prod ... "
        cp .env.prod .env
    ;;
    esac
else
    echo "env file exists."
fi

# php artisan migrate
php artisan clear
php artisan optimize

# Fix files ownership.
chown -R www-data .
chown -R www-data /var/www/html/storage
chown -R www-data /var/www/html/storage/logs
chown -R www-data /var/www/html/storage/framework
chown -R www-data /var/www/html/storage/framework/sessions
chown -R www-data /var/www/html/bootstrap
chown -R www-data /var/www/html/bootstrap/cache

# Set correct permission.
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/storage/logs
chmod -R 775 /var/www/html/storage/framework
chmod -R 775 /var/www/html/storage/framework/sessions
chmod -R 775 /var/www/html/bootstrap
chmod -R 775 /var/www/html/bootstrap/cache

php-fpm -D
nginx -g "daemon off;"
