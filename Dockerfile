FROM ubuntu:12.04
MAINTAINER Andres Mazza <andres.mazza@gmail.com>


#ENV N98_MAGERUN_VERSION 1.96.1
#ENV N98_MAGERUN_URL https://raw.githubusercontent.com/netz98/n98-magerun/$N98_MAGERUN_VERSION/n98-magerun.phar

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y git curl apache2 php5 libapache2-mod-php5 php5-mcrypt php5-mysql php5-xdebug php5-curl php5-gd php5-geoip

#RUN curl -o /usr/local/bin/n98-magerun $N98_MAGERUN_URL \
#    && chmod +x /usr/local/bin/n98-magerun

# Install tools
RUN apt-get install -y net-tools

# Install app
RUN rm -rf /var/www/*
#ADD src /var/www

#  PHP.ini
RUN sed -i '1 a max_execution_time=30' /etc/php5/apache2/php.ini

# Config xDebug 
RUN sed -i '1 a xdebug.remote_autostart=off' /etc/php5/conf.d/xdebug.ini
RUN sed -i '1 a xdebug.remote_enable=on' /etc/php5/conf.d/xdebug.ini
RUN sed -i '1 a xdebug.remote_handler=dbgp' /etc/php5/conf.d/xdebug.ini
RUN sed -i '1 a xdebug.remote_port = 9000' /etc/php5/conf.d/xdebug.ini
RUN sed -i '1 a xdebug.remote_server = 127.0.0.1' /etc/php5/conf.d/xdebug.ini
RUN sed -i '1 a xdebug.remote_mode = req' /etc/php5/conf.d/xdebug.ini
RUN sed -i '1 a output_buffering = off' /etc/php5/conf.d/xdebug.ini
RUN sed -i '1 a xdebug.remote_log = /var/log/xdebug.log' /etc/php5/conf.d/xdebug.ini


RUN a2enmod rewrite
RUN a2enmod headers
RUN chown -R www-data:www-data /var/www
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]

