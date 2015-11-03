#!/bin/sh

cd /ruby/openproject
cp /var/config/configuration.yml config/configuration.yml
cp /var/config/database.yml config/database.yml
trap "echo TRAPed signal" HUP INT QUIT KILL TERM
/etc/init.d/apache2 restart
su openproject -c 'source /home/openproject/.profile && bundle exec rake db:create:all && \
	bundle exec rake generate_secret_token && \
	RAILS_ENV="production" bundle exec rake db:migrate && \
	RAILS_ENV="production" bundle exec rake db:seed && \
	RAILS_ENV="production" bundle exec rake assets:precompile'

read
echo "stopping openproject"
/usr/sbin/apachectl stop

echo "exited $0"
