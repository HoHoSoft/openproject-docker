FROM debian:jessie
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#Create openrpoject group and user
RUN groupadd openproject && useradd --create-home -p ! --gid openproject openproject

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
			libmysqlclient-dev # nokogiri \
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

#Prepare for Ruby installation
RUN mkdir /ruby && chmod -R 771 /ruby && chown -R openproject:openproject /ruby

#Install Ruby & Node ... & Openproject
ADD ./installruby.sh /ruby/installruby.sh
RUN chmod a+x /ruby/installruby.sh
USER openproject
RUN /ruby/installruby.sh

USER root
ADD ./installopenproject.sh /ruby/installopenproject.sh
RUN chmod a+x /ruby/installopenproject.sh
USER openproject
RUN /ruby/installopenproject.sh

#Install Apache2
USER root
ADD ./installapache.sh /ruby/installapache.sh
RUN chmod a+x /ruby/installapache.sh
USER openproject
RUN /ruby/installapache.sh

USER root
RUN touch /etc/apache2/mods-available/passenger.load
RUN echo "LoadModule passenger_module /home/openproject/.rbenv/versions/2.1.6/lib/ruby/gems/2.1.0/gems/passenger-5.0.21/buildout/apache2/mod_passenger.so" >> /etc/apache2/mods-available/passenger.load
RUN echo -e "<IfModule mod_passenger.c>\n" \
   "  PassengerRoot /home/openproject/.rbenv/versions/2.1.6/lib/ruby/gems/2.1.0/gems/passenger-5.0.21 \n"\
   "  PassengerDefaultRuby /home/openproject/.rbenv/versions/2.1.6/bin/ruby \n"\
   "</IfModule>" >> /etc/apache2/mods-available/passenger.conf
RUN cat /etc/apache2/mods-available/passenger.conf
RUN a2enmod passenger

#Now setup a config
RUN touch /etc/apache2/sites-available/openproject.conf
RUN echo -e "SetEnv EXECJS_RUNTIME Disabled\n"\
"\n"\
"<VirtualHost *:80>\n"\
"   ServerName yourdomain.com\n"\
"   # !!! Be sure to point DocumentRoot to 'public'!\n"\
"   DocumentRoot /ruby/openproject/public\n"\
"   <Directory /ruby/openproject/public>\n"\
"      # This relaxes Apache security settings.\n"\
"      AllowOverride all\n"\
"      # MultiViews must be turned off.\n"\
"      Options -MultiViews\n"\
"      # Uncomment this if you're on Apache >= 2.4:\n"\
"      Require all granted\n"\
"   </Directory>\n"\
"</VirtualHost>\n" >> /etc/apache2/sites-available/openproject.conf
RUN a2dissite 000-default
RUN a2ensite openproject


RUN cd /
ADD ./run.sh /run.sh
RUN chmod +x /run.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

################	##############################
VOLUME ["/var/config", "/ruby/openproject/files"]
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
