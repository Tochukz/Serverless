#!/bin/bash
# Filename: config.sh
# Task: Install Nginx and PHP on Amazon Linux2

echo OS Version: 
cat /etc/os-release

sudo yum update -y

## Install Nginx
sudo amazon-linux-extras install nginx1 -y
sudo service nginx start

# Enable Nginx to start at Boot time
sudo chkconfig nginx o

## Install git 
sudo yum install git -y

## Install PHP
# Add EPEL and Remi Repositories
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
# Update Yum index to confirm the two reposiories are working
sudo yum makecache
# Install yum-utils
sudo yum -y install yum-utils
# Check for available Version on OS repository
sudo amazon-linux-extras | grep php
# Enable the Repo
sudo yum-config-manager --disable 'remi-php*'
sudo amazon-linux-extras enable php8.0
# Install PHP and standard extentions and PHP-FPM
sudo yum clean metadata
sudo yum -y install php-{pear,cgi,pdo,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip}
sudo yum install php-mysqlnd php-fpm

## Install composer
sudo curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer
composer --version


## Setup Visual host
sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
# Edit the /etc/nginx/nginx.conf file and add the lines at the end of the http {} block
# include /etc/nginx/sites-enabled/*.conf;
# server_names_hash_bucket_size 64;

# Setup website directory
sudo mkdir -p /var/www/mysite.com/html
sudo chown -R $USER:$USER /var/www/mysite.com/html
sudo chmod -R 755 /var/www