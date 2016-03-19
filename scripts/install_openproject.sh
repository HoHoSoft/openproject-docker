#!/bin/bash

# Install OpenProject
cd /home/openproject
source /home/openproject/.profile
git clone https://github.com/opf/openproject-ce.git --branch stable/5 --depth 1 openproject
cd openproject
git checkout v5.0.7
gem install bundler
npm config set registry http://registry.npmjs.org/
bundle install --path vendor/bundle --without postgres sqlite development test therubyracer
npm install
