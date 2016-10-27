#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

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

apt-get install -y mysql-server-5.6

mysql -e "CREATE USER 'vagrant'@'localhost' IDENTIFIED BY '';"
mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'vagrant'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# PHP and its tools installation
# ==============================

add-apt-repository ppa:ondrej/php
apt-get update

apt-get install -y php7.1 php7.1-fpm php7.1-mysql php7.1-curl php7.1-intl php7.1-gd php7.1-mbstring php7.1-xml php7.1-zip php7.1-mcrypt

# Composer's installation
# =======================

cd /var/www
curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

# SSH Key and folders
# ===================

cp /root/.ssh/id_rsa /home/vagrant/.ssh/
cp /root/.ssh/id_rsa.pub /home/vagrant/.ssh/

chown -R vagrant: /home/vagrant/.ssh/

chmod 700 /home/vagrant/.ssh/id_rsa
chmod 700 /home/vagrant/.ssh/id_rsa.pub

chown -R vagrant: /var/www

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

# Elasticsearch's install
# =======================

apt-get update
apt-get install openjdk-7-jre

add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer

wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.1/elasticsearch-2.4.1.deb
dpkg -i elasticsearch-2.4.1.deb
update-rc.d elasticsearch defaults
service elasticsearch start
rm elasticsearch-2.4.1.deb

export DEBIAN_FRONTEND=dialog

