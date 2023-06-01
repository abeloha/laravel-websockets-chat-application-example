#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    echo "Running composer install"
    composer install --no-progress --no-interaction
else
    echo "Composer already installed. Skipping."
fi

if [ ! -f ".env" ]; then
    echo "creating env file..."
    cp .env.example .env
else
    echo "env file already exists"
fi

role=${CONTAINER_ROLE:-app}

if [ "$role" == "app" ]; then
    php artisan migrate
    php artisan key:generate
    php artisan serve --port=$PORT --host=0.0.0.0 --env=.env

    exec docker-php-entrypoint "$@"
elif [ "$role" == "queue" ]; then
    echo "runing queue"
    php /var/www/artisan queue:work --verbose --tries=3 --timeout=180
fi





# Error runing the .sh
# Error response from daemon: failed to create shim: OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "docker/entrypoint.sh": permission denied: unknown
# Solved by changing the permission:configs:
# chmod +x docker/entrypoint.sh
