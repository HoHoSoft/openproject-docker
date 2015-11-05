CREATE DATABASE openproject CHARACTER SET utf8;
CREATE USER 'openproject'@'%' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON openproject.* TO 'openproject'@'%';
FLUSH PRIVILEGES;
