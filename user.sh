#!/bin/bash
# Copy this script to a permanent location on the instance
cp "$0" /home/ubuntu/userdata.sh

# Update and upgrade packages
echo "Updating and upgrading packages..."
sudo apt update && sudo apt upgrade -y

# Install MySQL client to connect to RDS
echo "Installing MySQL client..."
sudo apt install -y mysql-client

# Install Apache, PHP, and other required packages
echo "Installing Apache and PHP..."
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-gd

# Wait for the services to stabilize
sleep 5

# RDS Credentials
wordpress_db_endpoint="wordpress-db.cvqhmp3wgplm.us-east-1.rds.amazonaws.com"
db_username="wordpress_user"
db_password="supersecret"
db_name="wordpress_db"

# Connect to RDS and create the WordPress database and user permissions
echo "Connecting to RDS and setting up the WordPress database..."
mysql -h "${wordpress_db_endpoint}" -u "${db_username}" -p"${db_password}" <<EOF
CREATE DATABASE IF NOT EXISTS ${db_name};
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_username}'@'%';
FLUSH PRIVILEGES;
EOF

# Check if the database creation was successful
if [ $? -ne 0 ]; then
  echo "Failed to create database or set permissions."
  exit 1
fi

# Download and set up WordPress
echo "Downloading and setting up WordPress..."
cd /var/www/html
sudo wget -q https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo mv wordpress/* ./
sudo rm -rf wordpress latest.tar.gz

# Configure wp-config.php with RDS details
echo "Configuring wp-config.php..."
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/${db_name}/" wp-config.php
sudo sed -i "s/username_here/${db_username}/" wp-config.php
sudo sed -i "s/password_here/${db_password}/" wp-config.php
sudo sed -i "s/localhost/${wordpress_db_endpoint}/" wp-config.php

# Set permissions for WordPress files
echo "Setting permissions for WordPress files..."
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo rm /var/www/html/index.html

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2

echo "WordPress setup completed successfully."
