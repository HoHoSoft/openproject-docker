FROM debian:jessie

# Always use bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#Installation of essentials
RUN apt-get update  -y &&  apt-get install -y \
			automake \
			apache2 \
			apache2-threaded-dev \
			build-essential \
			bison \
			curl \
			git \
			libapr1-dev \
			libaprutil1-dev \
			libcurl4-gnutls-dev \
			libffi-dev \
			libgdbm-dev \
			libmysqlclient-dev \
			libncurses5-dev \
			libreadline-dev \
			libssl-dev \
			libtool \
			libxml2 \
			libxml2-dev \
			libxslt1-dev \
			libyaml-dev \
			memcached \
			supervisor \
			zlib1g-dev

# Create openproject group and user
RUN groupadd openproject && useradd --create-home -p ! --gid openproject openproject

# Prepare for Ruby installation
RUN mkdir /ruby && chmod -R 771 /ruby && chown -R openproject:openproject /ruby

# Add install and run scripts
ADD ./scripts/*.sh /scripts/
RUN chmod a+x /scripts/*.sh

# Install required software
USER openproject
RUN /scripts/install_ruby_node.sh
RUN /scripts/install_openproject.sh
RUN /scripts/install_passenger.sh

# Enable passenger
USER root
ADD ./scripts/passenger.* /etc/apache2/mods-available/
RUN a2enmod passenger

# Apache site config
ADD ./scripts/openproject.conf /etc/apache2/sites-available/openproject.conf
RUN a2dissite 000-default && a2ensite openproject

ADD ./scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


VOLUME ["/var/config", "/ruby/openproject/files"]
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
