FROM php:7.4-apache

MAINTAINER Destiny NV <development@destiny.be>

# Install cli tools
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        cron \
        git \
        default-mysql-client \
        inotify-tools \
        nano \
        sudo \
        supervisor \
        unzip \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Install required PHP libraries
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        libcurl3-dev \
        libicu-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libjpeg62-turbo-dev \
        libonig-dev \
        libpq-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        zlib1g-dev \
        libcurl4-openssl-dev \
        libssl-dev \
    && docker-php-ext-configure bcmath \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j "$(nproc)" \
        bcmath \
        curl \
        gd \
        iconv \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        soap \
        sockets \
        xmlrpc \
        zip \
        calendar \
	&& apt-get purge -y \
        libcurl3-dev \
        libicu-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libjpeg62-turbo-dev \
        libonig-dev \
        libpq-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        zlib1g-dev \
        libcurl4-openssl-dev \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Yii framework bash autocompletion
RUN curl -sS -L https://raw.githubusercontent.com/yiisoft/yii2/master/contrib/completion/bash/yii -o /etc/bash_completion.d/yii
RUN echo ". /etc/bash_completion.d/yii" >> /root/.bashrc

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy PHP configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Enable apache2 modules
RUN a2enmod rewrite headers

# Setup system
WORKDIR /opt/app/

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80
STOPSIGNAL SIGTERM

CMD ["docker/run-services.sh"]
