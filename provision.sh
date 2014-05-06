#!/bin/bash

# Include parameters
source /vagrant/parameters.sh

# Update the box repositories and update debian's components
# ==========================================================
apt-get update
apt-get dist-upgrade



# Essential packages (git, vim, curl, build-essential)
# ==================
apt-get install -y build-essential vim curl

apt-get install -y python-software-properties



# Git's installation and configuration
# ====================================
apt-get install -y git-core

git config --global color.ui true           # enable color
git config --global core.fileMode false     # ignore file chmod

git config --global user.name "$GIT_USERNAME"
git config --global user.email $GIT_EMAIL



# Nginx's installation and configuration
# ======================================
apt-get install -y nginx



# MariaDB's installation
# ======================

# +++ adding mariadb repositories...
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
add-apt-repository 'deb http://ftp.igh.cnrs.fr/pub/mariadb/repo/10.0/debian wheezy main'
apt-get update

# +++ installing mariadb...
export DEBIAN_FRONTEND=noninteractive
apt-get install -y mariadb-server
export DEBIAN_FRONTEND=dialog



# PHP and its tools installation
# ==============================

# +++ adding php 5.5.x repositories...
# add-apt-repository ppa:ondrej/php5
# apt-get update

# +++ installing php 5.5.x and its tools...
apt-get install -y php5-cli php5-mysql php5-curl php5-mcrypt php5-gd php-pear php5-xdebug php5-intl php5-fpm

# +++ configuring xdebug for php-cli...
echo -e "\n[xdebug]\nxdebug.max_nesting_level = 250\nxdebug.var_display_max_depth = 7" >> /etc/php5/cli/php.ini

# +++ configuring xdebug for php-fpm...
echo -e "\n[xdebug]\nxdebug.max_nesting_level = 250\nxdebug.var_display_max_depth = 7" >> /etc/php5/fpm/php.ini

# +++ configuring php-cli date timezone...
sed 's#;date.timezone\([[:space:]]*\)=*#date.timezone\1=\1\"'"$PHP_DATE_TIMEZONE"'\"#g' /etc/php5/cli/php.ini > /etc/php5/cli/php.ini.tmp
mv /etc/php5/cli/php.ini.tmp /etc/php5/cli/php.ini

# +++ configuring php-fpm date timezone...
sed 's#;date.timezone\([[:space:]]*\)=*#date.timezone\1=\1\"'"$PHP_DATE_TIMEZONE"'\"#g' /etc/php5/fpm/php.ini > /etc/php5/fpm/php.ini.tmp
mv /etc/php5/fpm/php.ini.tmp /etc/php5/fpm/php.ini



# Application's configuration
# ===========================
if [ ! -s "/var/www/$APPLICATION_NAME" ];
then
    
    if [ ! -s "/vagrant/www" ];
    then
        mkdir /vagrant/www
    fi

    ln -fs /vagrant/www /var/www

    cd /var/www
    curl -sS https://getcomposer.org/installer | php

    if [ "$PROJECT_GIT_REPOSITORY" != "" ];
    then
        # cloning the project...
        git clone $PROJECT_GIT_REPOSITORY /var/www/$APPLICATION_NAME
        cd /var/www/$APPLICATION_NAME

        if [ "$PROJECT_GIT_BRANCH" != "master" ];
        then
            # create new branch locally
            git checkout -b $PROJECT_GIT_BRANCH --track origin/$PROJECT_GIT_BRANCH
        fi

        if [ -f "/var/www/$APPLICATION_NAME/composer.json" ];
        then
            php /var/www/composer.phar self-update
            php /var/www/composer.phar update
        fi
    fi

    if [ -f "/vagrant/nginx/$APPLICATION_NAME" ];
    then
        cp /vagrant/nginx/$APPLICATION_NAME /etc/nginx/sites-enabled/$APPLICATION_NAME
    else
        cp /vagrant/nginx/default.dist /etc/nginx/sites-enabled/$APPLICATION_NAME
        
        # set application server name...
        sed 's/APPLICATION_SERVER_NAME#'$APPLICATION_SERVER_NAME'#g' /etc/nginx/sites-enabled/$APPLICATION_NAME > /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp
        mv /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp /etc/nginx/sites-enabled/$APPLICATION_NAME

        # set application root index...
        sed 's#APPLICATION_ROOT#'$APPLICATION_NAME$APPLICATION_ROOT'#g' /etc/nginx/sites-enabled/$APPLICATION_NAME > /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp
        mv /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp /etc/nginx/sites-enabled/$APPLICATION_NAME

        # set application error log and access log
        sed 's#APPLICATION_ERROR_LOG#'$APPLICATION_NAME'#g' /etc/nginx/sites-enabled/$APPLICATION_NAME > /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp
        mv /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp /etc/nginx/sites-enabled/$APPLICATION_NAME
        sed 's#APPLICATION_ACCESS_LOG#'$APPLICATION_NAME'#g' /etc/nginx/sites-enabled/$APPLICATION_NAME > /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp
        mv /etc/nginx/sites-enabled/$APPLICATION_NAME.tmp /etc/nginx/sites-enabled/$APPLICATION_NAME
    fi

    service nginx restart

fi