#!/bin/sh

source /home/openproject/.profile

cd /ruby/openproject
cp /var/config/configuration.yml config/configuration.yml
cp /var/config/database.yml config/database.yml
cp /var/config/Gemfile.plugins Gemfile.plugins

# if Gemfile.plugins was changed
bundle install
npm install

bundle exec rake db:create:all
bundle exec rake generate_secret_token
RAILS_ENV="production" bundle exec rake db:migrate
RAILS_ENV="production" bundle exec rake db:seed
RAILS_ENV="production" bundle exec rake assets:precompile
