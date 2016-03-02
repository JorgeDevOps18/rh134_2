FROM ubuntu:14.04
#TARGET_IMAGE_NAME apache_proxy:1.0
ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Sergii Kipot "s.kipot@oberthur.com"

RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	dpkg-reconfigure locales

RUN apt-get update && \
    apt-get install -y apache2

# Start/stop to create needed folders
RUN service apache2 start
RUN service apache2 stop

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www

# Enable modules
RUN a2enmod ssl headers proxy_http

# Remove default config
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]