#!/bin/bash

cp /var/config/configuration.yml /home/openproject/openproject/config/configuration.yml
cp /var/config/database.yml /home/openproject/openproject/config/database.yml
cd ~/openproject
bundle exec rake db:create:all
bundle exec rake generate_secret_token
RAILS_ENV="production" bundle exec rake db:migrate
RAILS_ENV="production" bundle exec rake db:seed
RAILS_ENV="production" bundle exec rake assets:precompile
