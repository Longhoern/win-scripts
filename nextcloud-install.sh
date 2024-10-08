#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Update package lists and upgrade existing packages
apt update && apt upgrade -y

# Install required packages
apt install -y apache2 mariadb-server libapache2-mod-php php-gd php-mysql \
php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip unzip

# Configure MariaDB
mysql <<EOF
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '9ZDCc6L*p^eJk8i!';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and install Nextcloud
wget https://download.nextcloud.com/server/releases/latest.zip
sha256sum -c latest.zip.sha256 < latest.zip
unzip latest.zip
cp -r nextcloud /var/www
chown -R www-data:www-data /var/www/nextcloud

# Create Apache configuration for Nextcloud
cat > /etc/apache2/sites-available/nextcloud.conf <<EOF
Alias /nextcloud "/var/www/nextcloud/"

<Directory /var/www/nextcloud/>
  Require all granted
  AllowOverride All
  Options FollowSymLinks MultiViews
  
  <IfModule mod_dav.c>
    Dav off
  </IfModule>
</Directory>
EOF

# Enable Nextcloud site and required Apache modules
a2ensite nextcloud.conf
a2enmod rewrite headers env dir mime

# Reload Apache to apply changes
systemctl reload apache2

echo "Nextcloud installation complete. Please access it at http://your_server_ip/nextcloud"
