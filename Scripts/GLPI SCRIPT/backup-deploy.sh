#!/bin/bash
echo "Enter the password for glpi db user"
read DBPASS
echo "Enter the domain\username for access to backup folder"
read ADUSER
echo "Enter the password for domain user"
read ADPASS

apt update -y
timedatectl set-timezone Asia/Yekaterinburg

apt install software-properties-common cifs-utils -y
add-apt-repository ppa:ondrej/php

mkdir -p /etc/backup/files

echo username=$ADUSER > /etc/backup/.smbuser
echo password=$ADPASS >> /etc/backup/.smbuser
echo domain=corp >> /etc/backup/.smbuser
echo "//172.16.30.19/backup/web1-v-glpi /etc/backup/files cifs credentials=/etc/backup/.smbuser 0 0" >> /etc/fstab

mount -a

tar -xf /etc/backup/files/$(ls -t /etc/backup/files/ | head -1) -C /etc/backup/

apt update -y
apt install -y mariadb-server mariadb-client apache2
systemctl disable --now apparmor
systemctl enable --now mariadb

mysql_secure_installation



mysql -u root -p < /etc/backup/var/www/sqlbackup/$(ls -t /etc/backup/var/www/sqlbackup/ | head -1)
cp -R /etc/backup/var/www/html/glpi /var/www/html/glpi

apt install php8.0-fpm php8.0-bz2 php8.0-common php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-mysql php8.0-gd php8.0-imap php8.0-ldap php-cas php8.0-bcmath php8.0-xml php8.0-cli php8.0-zip php8.0-sqlite3 php8.0-apcu -y
apt remove --purge --autoremove php8.1*

chown -R www-data:www-data /var/www/html/glpi

#mkdir /etc/ca
#openssl genrsa -out /etc/ca/server.key 2048
#openssl req -x509 -new -key /etc/ca/server.key -days 10000 -out /etc/ca/server.crt
rm -rf /etc/apache2/sites-enabled/*
rm -rf /etc/apache2/sites-available/*
cp /etc/backup/files/glpi.conf /etc/apache2/sites-available/glpi.conf
ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/

systemctl enable --now apache2 php8.0-fpm
a2enmod proxy_fcgi setenvif
a2enconf php8.0-fpm
echo "Add FQDN to config and enable nginx"
