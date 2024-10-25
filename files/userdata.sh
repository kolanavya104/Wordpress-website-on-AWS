#!/bin/bash
  sudo apt-get update -y
  sudo apt-get install mysql-client -y
  sudo apt-get install apache2 apache2-utils -y
  sudo apt install php php-mysql libapache2-mod-php -y
  sudo apt-get install php   # for Ubuntu or Debian-based systems
  sudo apt-get install libapache2-mod-php   # for Ubuntu or Debian
  sudo apt-get install php7.4 libapache2-mod-php7.4 php7.4-mcrypt php7.4-curl php7.4-gd php7.4-xmlrpc php7.4-mysql -y
  sudo a2enmod rewrite
  sudo service apache2 restart
  sudo wget -c http://wordpress.org/wordpress-5.1.1.tar.gz
  sudo tar -xzvf wordpress-5.1.1.tar.gz
  sleep 20
  sudo mkdir -p /var/www/html/
  sudo rsync -av wordpress/* /var/www/html/
  sudo chown -R www-data:www-data /var/www/html/
  sudo chmod -R 755 /var/www/html/
  sudo rm /var/www/html/index.html
  sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  sudo chmod 644 /var/www/html/wordpress/index.php
  sudo service apache2 restart
  sudo systemctl restart apache2  
  sleep 20
