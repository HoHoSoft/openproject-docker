#!/bin/bash

# Install ruby
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/openproject/.profile
echo 'eval "$(rbenv init -)"' >> /home/openproject/.profile
source /home/openproject/.profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

rbenv install 2.1.6
rbenv rehash
rbenv global 2.1.6

# Install Node
git clone https://github.com/OiNutter/nodenv.git ~/.nodenv
echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.profile
echo 'eval "$(nodenv init -)"' >> ~/.profile
source ~/.profile
git clone git://github.com/OiNutter/node-build.git ~/.nodenv/plugins/node-build

nodenv install 0.12.7
nodenv rehash
nodenv global 0.12.7
