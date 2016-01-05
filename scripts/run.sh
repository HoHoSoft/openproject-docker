#!/bin/sh

cd /home/openproject/openproject
cp /var/config/configuration.yml config/configuration.yml
cp /var/config/database.yml config/database.yml
cp /var/config/Gemfile.local Gemfile.local

if [ ! -f /var/config/.setup-complete ]; then
  echo -e "Running setup\n"
  su -c "/scripts/setup.sh" openproject

  touch /var/config/.setup-complete
fi

echo -e "Starting supervisor\n"
supervisord -c /etc/supervisor/conf.d/supervisord.conf -n
