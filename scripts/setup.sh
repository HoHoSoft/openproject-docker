#!/bin/sh

source /home/openproject/.profile
export RAILS_ENV="production"

bundle install
npm install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake assets:precompile

echo "export SECRET_KEY_BASE=`./bin/rake secret`" >> /home/openproject/.profile
