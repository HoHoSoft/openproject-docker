FROM debian:jessie
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#Create openrpoject group and user
RUN groupadd openproject
RUN useradd --create-home -p ! --gid openproject openproject

#Installation of essentials
RUN apt-get update  -y
RUN apt-get install -y zlib1g-dev build-essential \
                    libssl-dev libreadline-dev            \
                    libyaml-dev libgdbm-dev               \
                    libncurses5-dev automake              \
                    libtool bison libffi-dev git curl     \
                    libxml2 libxml2-dev libxslt1-dev libmysqlclient-dev # nokogiri
#Install memcached
RUN apt-get install -y memcached

#Prepare for Ruby installation
RUN mkdir /ruby
RUN chmod -R 771 /ruby
RUN chown -R openproject:openproject /ruby
 
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
RUN apt-get install -y apache2 libcurl4-gnutls-dev      \
                               apache2-threaded-dev libapr1-dev \
                               libaprutil1-dev

RUN chmod o+x "/ruby/openproject"
USER openproject
RUN cd /ruby/openproject
RUN gem install passenger
RUN passenger-install-apache2-module -a
USER root
RUN touch /etc/apache2/mods-available/passenger.load
RUN echo "" >> /etc/apache2/mods-available/passenger.load




RUN cd /
ADD ./run.sh /run.sh
RUN chmod +x /run.sh

################	##############################
VOLUME ["/var/config"]
EXPOSE 80
CMD ["/run.sh"]
