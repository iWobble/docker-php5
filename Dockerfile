FROM iwobble/nginx

MAINTAINER Jared Mashburn "jmashburn@iwobble.com"

RUN dnf update
RUN \
    dnf install -y php-fpm \
    php-mysql \
    php-apc \
    php-mcrypt \
    php-curl \
    php-cli \
    php-gd \
    php-zip \
    php-pgsql \
    php-pear \
    php-pecl-imagick \
    supervisor
    
RUN dnf clean all

RUN \
    mkdir /opt/bin && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/opt/bin/ && \
    mv /opt/bin/composer.phar /opt/bin/composer

ENV PATH /opt/bin:$PATH 

RUN \
    mkdir -p /var/www/html && \
    echo "<?php phpinfo();" > /var/www/html/index.php

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php.ini

ADD default.conf /etc/nginx/conf.d/default.conf
ADD supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]
