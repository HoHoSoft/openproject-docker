#!/bin/bash

# Install Openproject
source /home/openproject/.profile
git clone https://github.com/opf/openproject.git /ruby/openproject
cd /ruby/openproject
git checkout v4.2.9
gem install bundler
bundle install --path vendor/bundle --without postgres sqlite rmagick development test therubyracer
npm install
