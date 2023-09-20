FROM php:7.4-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    jpegoptim optipng pngquant gifsicle \
    locales \
    unzip \
    vim \
    zip \
    supervisor

# Install PHP extensions

# Graphics Draw
# Install system dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    vim  \
    nano \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    librabbitmq-dev \
    libssl-dev \
    gettext-base \
    rsync  \
    ssh  \
    sshpass \
    libpq-dev \
    libldb-dev \
    libldap2-dev \
    && pecl install amqp \
    && docker-php-ext-enable amqp

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets pdo pdo_pgsql pgsql ldap

# Clear cache
#RUN apk update && apk add --no-cache supervisor

RUN mkdir -p "/etc/supervisor/logs"

COPY ./supervisor.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]

