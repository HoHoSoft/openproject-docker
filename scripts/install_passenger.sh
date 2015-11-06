#!/bin/bash

# Install passenger
cd ~
source /home/openproject/.profile
chmod o+x "/ruby/openproject"
cd /ruby/openproject && gem install passenger -v 5.0.21
passenger-install-apache2-module -a
