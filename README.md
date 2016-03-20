# openproject-docker
Docker container for OpenProject. It uses a MySQL database, [nginx](http://nginx.org) and [Puma server](http://puma.io). This setup is heavily inspired by [abevoelker/docker-openproject](https://github.com/abevoelker/docker-openproject) but has some differences and advantages:
* It uses MySQL instead of PostgreSQL
* It has support for plugins
* Based on OpenProject CE with all official plugins preinstalled
* Specific versions of OpenProject instead of latest stable only

## Installation
First you have to clone this repository: `git clone https://github.com/HoHoSoft/openproject-docker.git`. Before you start the container you should change the default database password `my_password` and `my-secret-pw` in `docker-compose.yml` to something more secure. Make sure to adjust the `config/database.yml` as well. Now you can run `docker-compose up` to build the container and link it with a [MySQL 5.6 container](https://hub.docker.com/_/mysql/). After some time OpenProject will be available on (http://localhost:8080). The default username and password is `admin` for both.

If you prefer to use your own MySQL database you can build the container with `docker build .` and adjust the `config/database.yml` to your needs. To setup the database you can use the `db_init.sql` script. Change the password first!

### SMTP Configuration
To enable e-mail notifications from OpenProject change the `production` section in `config/configuration.yml` to the correct values:
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
```
After a restart of the container the changes will take effect.

### Installing Plugins
To install a new plugin add the gem to `config/Gemfile.local` and delete the `config/.setup-complete` so that the container will rerun installation and database migration. Then restart the container.
