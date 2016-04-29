#!/bin/bash

# Update the box repositories and update debian's components
# ==========================================================
apt-get update
apt-get dist-upgrade


# Essential packages (vim, curl, build-essential)
# ==================
apt-get install -y build-essential vim curl

apt-get install -y python-software-properties


# Git's installation and configuration
# ====================================
add-apt-repository ppa:git-core/ppa
apt-get update
apt-get install -y git-core git

git config --global color.ui true           # enable color
git config --global core.fileMode false     # ignore file chmod

git config --global user.name "Eric Chau"
git config --global user.email eriic.chau@gmail.com

# Nginx's installation and configuration
# ======================================

# +++ adding nginx 1.6 repositories...
add-apt-repository ppa:nginx/stable
apt-get update

# +++ installing nginx 1.6...
apt-get install -y nginx


# MySQL's installation
# ======================

export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server
export DEBIAN_FRONTEND=dialog


# PHP and its tools installation
# ==============================

add-apt-repository ppa:ondrej/php
apt-get update

apt-get install -y php7.0 php7.0-fpm php7.0-mysql php7.0-curl php7.0-intl php7.0-gd php7.0-mbstring php7.0-xml php7.0-zip php7.0-mcrypt

# +++ configuring xdebug for php-cli...
# echo -e "\n[xdebug]\nxdebug.max_nesting_level = 250\nxdebug.var_display_max_depth = 7" >> /etc/php5/cli/php.ini

# +++ configuring xdebug for php-fpm...
# echo -e "\n[xdebug]\nxdebug.max_nesting_level = 250\nxdebug.var_display_max_depth = 7" >> /etc/php5/fpm/php.ini

# +++ configuring php-cli date timezone...
sed 's#;date.timezone\([[:space:]]*\)=*#date.timezone\1=\1\"'"$PHP_DATE_TIMEZONE"'\"#g' /etc/php/7.0/cli/php.ini > /etc/php/7.0/cli/php.ini.tmp
mv /etc/php/7.0/cli/php.ini.tmp /etc/php/7.0/cli/php.ini

# +++ configuring php-fpm date timezone...
sed 's#;date.timezone\([[:space:]]*\)=*#date.timezone\1=\1\"'"$PHP_DATE_TIMEZONE"'\"#g' /etc/php/7.0/fpm/php.ini > /etc/php/7.0/fpm/php.ini.tmp
mv /etc/php/7.0/fpm/php.ini.tmp /etc/php/7.0/fpm/php.ini

# Composer's installation
# =======================

cd /var/www
curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

# Samba's installation and configuration
# ======================================
apt-get install -y samba

# +++ configuring samba...
service smbd stop
rm -rf /etc/samba/smb.conf
cp /vagrant/samba/smb.conf.dist /etc/samba/smb.conf
service smbd start

# +++ configuring user...
echo -ne "vagrant\nvagrant\n" | smbpasswd -L -a vagrant
smbpasswd -L -e vagrant

# Nodejs' installation
# ====================

apt-get install -y nodejs npm
ln -s /usr/bin/nodejs /usr/bin/node
