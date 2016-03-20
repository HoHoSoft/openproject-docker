#!/bin/bash
export RAILS_ENV="production"
source /home/openproject/.profile

# Execute the commands passed to this script
# e.g. "./env.sh bundle exec rake
exec "$@"
