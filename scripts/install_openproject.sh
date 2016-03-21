#!/bin/bash

# Install OpenProject
cd /home/openproject
source /home/openproject/.profile
git clone https://github.com/opf/openproject-ce.git --branch ${OPENPROJECT_VERSION} --depth 1 openproject
cd openproject
gem install bundler
npm config set registry http://registry.npmjs.org/
bundle install --path vendor/bundle --without postgres development docker test
npm install
