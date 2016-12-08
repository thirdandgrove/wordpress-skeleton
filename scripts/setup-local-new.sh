#!/bin/bash

. wordpress-skeleton/scripts/vendor/parse_yaml.sh

eval $(parse_yaml wordpress-skeleton/config.yaml "config_")

wp core download
wp core config --dbname=vagrant --dbuser=vagrant --dbpass=vagrant --ssh=vagrant@$config_hostname/vagrant

echo "Enter site title: "
read title

echo "Enter admin user: "
read user

echo "Enter admin password (SAVE THIS TO 1PASSWORD): "
read password

wp core install --url=$config_hostname --title=$title --admin_user=$user --admin_password=$password --admin_email=support@thirdandgrove.com --skip-email --ssh=vagrant@$config_hostname/vagrant

echo "Enter custom theme name: "
read theme

svn export https://github.com/thirdandgrove/tag-gulp-starter/trunk wp-content/themes/$theme

rm wp-content/themes/$theme/.gitignore
