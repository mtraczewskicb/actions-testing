FROM ubuntu:18.04
LABEL maintainer="Michal Traczewski <m.traczewski@chargebacks911.com>"

# Use USF Sources for faster DL
#COPY .docker/sources.list /etc/apt/sources.list
#
## Update & Prepare for Install
#RUN DEBIAN_FRONTEND=noninteractive apt-get update
#
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata
#
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl unzip gnupg2
#
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
#RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

#### Install dependencies.
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	apache2 \
	php7.4 \
	php7.4-cli \
	php7.4-bcmath \
	php7.4-common \
	php7.4-curl \
	php7.4-dev \
	php7.4-gd \
	php7.4-tidy \
	php7.4-json \
	php7.4-mbstring \
	php7.4-mysql \
	php7.4-opcache \
	php7.4-readline \
	php7.4-sqlite3 \
	php7.4-xml \
	php7.4-zip \
	pkg-php-tools \
	php-cli \
	php-pear \
    curl \
    unzip

# Install composer
RUN DEBIAN_FRONTEND=noninteractive curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# clean up the apt cache by removing /var/lib/apt/lists it reduces the image size, since the apt cache is not stored in a layer
RUN DEBIAN_FRONTEND=noninteractive rm -rf /var/lib/apt/lists/

#### Configure Apache
RUN DEBIAN_FRONTEND=noninteractive rm -rf /etc/apache2/sites-available/*

# Set apache env variable.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Own root folder by www-data
RUN ["chown","-R","www-data:www-data","/var/www"]

# Enable mod rewrite module.
RUN ["a2enmod","rewrite"]

# Setup XDEBUG settings.
#COPY .docker/xdebug.ini /etc/php/7.4/mods-available
#COPY .docker/xdebug.ini /etc/php/7.4/cli/conf.d/20-xdebug.ini

# Create XDEBUG Log File
#RUN mkdir -p /tmp/xdebug_log && touch /tmp/xdebug_log/xdebug.log
#RUN ["chown","-R","www-data:www-data","/tmp/xdebug_log"]

# PHP Set to 7.3 by default so wwitch to 7.3
#RUN DEBIAN_FRONTEND=noninteractive update-alternatives --set php /usr/bin/php7.4

# Start apache in foreground on startup.
CMD apachectl -D FOREGROUND
