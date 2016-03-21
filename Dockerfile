FROM debian:jessie

# Always use bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#Installation of essentials
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
			automake \
			build-essential \
			bison \
			curl \
			git \
			imagemagick \
			libapr1-dev \
			libaprutil1-dev \
			libcurl4-gnutls-dev \
			libffi-dev \
			libgdbm-dev \
			libmagickwand-dev \
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
			nginx \
			supervisor \
			zlib1g-dev && \
		apt-get clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create openproject group and user
RUN groupadd openproject && useradd --create-home -p ! --gid openproject openproject

# Set Openproject version
ENV OPENPROJECT_VERSION v5.0.16

# Add install scripts
ADD ./scripts/install_ruby_node.sh ./scripts/install_openproject.sh /scripts/
RUN chmod a+x /scripts/*.sh

# Install required software
USER openproject
RUN /scripts/install_ruby_node.sh
RUN /scripts/install_openproject.sh

# Configure nginx
USER root
ADD ./scripts/openproject.conf /etc/nginx/sites-available/openproject.conf
RUN sed -i "s/user www-data;/user openproject;/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/openproject.conf /etc/nginx/sites-enabled/

# Add run scripts
ADD ./scripts/run.sh ./scripts/env.sh ./scripts/setup.sh /scripts/
RUN chmod a+x /scripts/*.sh
ADD ./scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


VOLUME ["/var/config", "/home/openproject/openproject/files"]
EXPOSE 80
CMD ["/scripts/run.sh"]
