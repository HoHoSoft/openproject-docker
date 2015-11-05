#!/bin/sh

export HOME=/home/openproject/
echo $HOME && id
source /home/openproject/.profile

cd /ruby/openproject
cp /var/config/configuration.yml config/configuration.yml
cp /var/config/database.yml config/database.yml
echo "copied config"

# if Gemfile.plugins was changed
bundle install
npm install
echo "installation complete"

bundle exec rake db:create:all
bundle exec rake generate_secret_token
RAILS_ENV="production" bundle exec rake db:migrate
RAILS_ENV="production" bundle exec rake db:seed
RAILS_ENV="production" bundle exec rake assets:precompile
