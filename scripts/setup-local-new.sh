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
read -s password

wp core install --url=$config_hostname --title=$title --admin_user=$user --admin_password=$password --admin_email=support@thirdandgrove.com --skip-email --ssh=vagrant@$config_hostname/vagrant

echo "Enter theme slug: "
read slug

echo "Enter theme name: "
read name

svn export https://github.com/thirdandgrove/tag-gulp-starter/trunk wp-content/themes/$slug

rm wp-content/themes/$slug/.gitignore

cat > wp-content/themes/$slug/style.css << EOF
/*
Theme Name: $name
Author: Third & Grove
Version 1.0
*/
EOF

touch wp-content/themes/$slug/index.php

cd wp-content/themes/$slug && npm install && gulp
