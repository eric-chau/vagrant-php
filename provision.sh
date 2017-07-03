#!/bin/bash

export DEBIAN_FRONTEND=noninteractive


# Update the box repositories and update debian's components
# ==========================================================
apt update
apt dist-upgrade


# Essential packages (vim, curl, build-essential)
# ==================
apt install -y build-essential vim curl

apt install -y python-software-properties


# SSH Key and folders
# ===================

cp /root/.ssh/id_rsa /home/vagrant/.ssh/
cp /root/.ssh/id_rsa.pub /home/vagrant/.ssh/

chown -R vagrant: /home/vagrant/.ssh/

chmod 700 /home/vagrant/.ssh/id_rsa
chmod 700 /home/vagrant/.ssh/id_rsa.pub

chown -R vagrant: /var/www


# Git's installation and configuration
# ====================================
add-apt-repository ppa:git-core/ppa
apt update
apt install -y git-core git

git config --global color.ui true           # enable color

git config --global user.name "Eric Chau"
git config --global user.email eriic.chau@gmail.com


# Nginx's installation and configuration
# ======================================

# +++ adding nginx latest@tstable repositories...
add-apt-repository ppa:nginx/stable
apt update

# +++ installing nginx latest@tstable...
apt install -y nginx


# MySQL's installation
# ======================

apt install -y mysql-server-5.6

mysql -e "CREATE USER 'vagrant'@'localhost' IDENTIFIED BY '';"
mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'vagrant'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# PHP and its tools installation
# ==============================

add-apt-repository ppa:ondrej/php
apt update

apt install -y php7.1 php7.1-fpm php7.1-mysql php7.1-curl php7.1-intl php7.1-gd php7.1-mbstring php7.1-xml php7.1-zip php7.1-mcrypt
apt install -y php5.6 php5.6-fpm php5.6-mysql php5.6-curl php5.6-intl php5.6-gd php5.6-mbstring php5.6-xml php5.6-zip php5.6-mcrypt

# Composer's installation
# =======================

cd /var/www
curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

chown -R vagrant: /usr/local/bin/composer

# Samba's installation and configuration
# ======================================
apt install -y samba

# +++ configuring samba...
service smbd stop
rm -rf /etc/samba/smb.conf
cp /vagrant/samba/smb.conf.dist /etc/samba/smb.conf
service smbd start

# +++ configuring user...
echo -ne "vagrant\nvagrant\n" | smbpasswd -L -a vagrant
smbpasswd -L -e vagrant

# Nodejs and npm installation
# ====================

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt update
apt install -y nodejs
ln -s /usr/bin/nodejs /usr/bin/node

npm install npm@latest -g

# Redis' installation
# ====================

apt install -y redis-server

# Elasticsearch's install
# =======================

apt update
apt install -y openjdk-8-jre

add-apt-repository -y ppa:webupd8team/java
apt update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
apt install -y oracle-java8-installer

apt update
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

apt update
apt install -y elasticsearch
service elasticsearch start
update-rc.d elasticsearch defaults

export DEBIAN_FRONTEND=dialog
