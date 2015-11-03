#!/bin/bash

#Install Openproject (finally)
cd ~
source /home/openproject/.profile
git clone https://github.com/opf/openproject.git /ruby/openproject
cd /ruby/openproject
git checkout v4.2.9 # please use actual current stable version v4.2.X
gem install bundler
npm config set registry http://registry.npmjs.org/
bundle install --deployment --without postgres sqlite rmagick development test therubyracer
npm install
