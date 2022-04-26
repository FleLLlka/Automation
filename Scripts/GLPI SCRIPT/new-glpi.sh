#!/bin/bash
echo "Enter the password for glpi db user"
read DBPASS

apt update -y

apt install software-properties-common -y
add-apt-repository ppa:ondrej/php

apt update && apt upgrade -y
apt install -y mariadb-server nginx mariadb-client
systemctl disable --now apparmor
systemctl enable --now mariadb

mysql_secure_installation

mysql -u root -e "CREATE DATABASE glpidb;"
mysql -u root -e "CREATE USER 'glpidb'@'localhost' IDENTIFIED BY '$DBPASS';"
mysql -u root -e "GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

apt install php8.0-fpm php8.0-bz2 php8.0-common php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-mysql php8.0-gd php8.0-imap php8.0-ldap php-cas php8.0-bcmath php8.0-xml php8.0-cli php8.0-zip php8.0-sqlite3 php8.0-apcu -y

wget https://github.com/glpi-project/glpi/releases/download/10.0.0/glpi-10.0.0.tgz
tar -xvf glpi-10.0.0.tgz
mv glpi /var/www/glpi/

chown -R www-data:www-data /var/www/glpi

#mkdir /etc/ca
#openssl genrsa -out /etc/ca/server.key 2048
#openssl req -x509 -new -key /etc/ca/server.key -days 10000 -out /etc/ca/server.crt

cp ./glpi.conf /etc/nginx/conf.d/glpi.conf
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default
systemctl disable --now apache2
systemctl enable --now nginx php8.0-fpm
echo "Add FQDN to config and enable nginx"
