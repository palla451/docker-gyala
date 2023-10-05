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
    zip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions

#
## Aggiungi il repository PPA e installa il pacchetto Suricata
# Installa il pacchetto software-properties-common per abilitare add-apt-repository
RUN apt-get update && apt-get install -y software-properties-common

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
    python3 \
    python3-pip \
    suricata \
    && pecl install amqp \
    && docker-php-ext-enable amqp



#RUN apt-get update && apt-get install -y \
#    suricata \
#     pip install sigmalint \
##    yara-python \
##    python-yaml \
#    pip install sigmalint \

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets pdo pdo_pgsql pgsql ldap


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install specific version of Node.js with npm through nvm
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN nvm install v16.17.0

# Install Cron
RUN apt-get update && apt-get install -y cron
RUN echo "* * * * * root php /var/www/artisan schedule:run >> /var/log/cron.log 2>&1" >> /etc/crontab
RUN touch /var/log/cron.log

# Install sigmalint without user interaction
RUN pip3 install sigmalint

# Install python-yaml without user interaction
RUN pip3 install pyyaml

RUN pip3 install yara-python

RUN pip3 install suricata-update

CMD bash -c "cron && php-fpm"
