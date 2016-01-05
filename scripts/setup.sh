#!/bin/sh

source /home/openproject/.profile
export RAILS_ENV="production"

bundle install
npm install

bundle exec rake db:create:all
bundle exec rake generate_secret_token
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake assets:precompile
