# openproject-docker
Docker container for the latest openproject version 

## Installation
#### Configuration
To install OpenProject in Docker we use config/configuration.yml and config/database.yml, which are mounted directly into the container.
This setup expects a MySQL daemon running in another container (linked via db) or standalone (external link). 

##### configuration.yml
The minimal configuration consists of a production SMTP and enabling memcache.
```yml
production:
  email_delivery_method: :smtp
  smtp_address: smtp.gmail.com
  smtp_port: 587
  smtp_domain: smtp.gmail.com
  smtp_user_name: ***@gmail.com
  smtp_password: ****
  smtp_enable_starttls_auto: true
  smtp_authentication: plain

rails_cache_store: :memcache
```
##### configuration.yml
A minimal database configuration looks like this.
```yml
production:
  adapter: mysql2
  database: openproject
  host: db
  username: openproject
  password: my_password
  encoding: utf8
```

## Starting
For startup we use docker-compose.yml

### MySQL Database & User
You can use MySQL for Openproject, the Docker file expects a user with all grants on your openproject db.
If you don't have a databse setup for openrpoject you can do it as follows.
```mysql
CREATE DATABASE openproject CHARACTER SET utf8;
CREATE USER 'openproject'@'%' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON openproject.* TO 'openproject'@'localhost';
FLUSH PRIVILEGES;
```

