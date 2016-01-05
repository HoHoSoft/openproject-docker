#!/bin/bash

# Install OpenProject
cd /home/openproject
source /home/openproject/.profile
git clone https://github.com/opf/openproject.git
cd openproject
git checkout v4.2.9
gem install bundler
bundle install --path vendor/bundle --without postgres sqlite rmagick development test therubyracer
npm install
