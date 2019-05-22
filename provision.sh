#!/bin/bash

# global updates and upgrades…
# ============================
apt-get update
apt-get upgrade

echo "dockerbox" > /etc/hostname

# Installing essential packages…
# ==============================
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    vim \
    htop

# Installing git…
# ===============
sudo add-apt-repository ppa:git-core/ppa
apt-get update
apt-get install -y git

git config --global user.name "Eric Chau"
git config --global user.email eriic.chau@gmail.com
git config --global color.ui true

# Configuring ssh key…
# ====================

cp /tmp/.ssh/id_rsa       /root/.ssh/
cp /tmp/.ssh/id_rsa.pub   /root/.ssh/

cp /tmp/.ssh/id_rsa       /home/vagrant/.ssh/
cp /tmp/.ssh/id_rsa.pub   /home/vagrant/.ssh/

chown -R vagrant: /home/vagrant/.ssh/

chmod 700 /home/vagrant/.ssh/id_rsa
chmod 700 /home/vagrant/.ssh/id_rsa.pub

mkdir /var/www
chown -R vagrant: /var/www

# Installating samba…
# ===================
apt-get install -y samba

echo "$(cat /tmp/shared_smb.conf.dist)" >> /etc/samba/smb.conf
service smbd restart

echo -ne "vagrant\nvagrant\n" | smbpasswd -L -a vagrant
smbpasswd -L -e vagrant

# Installing docker and docker-compose…
# =====================================
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

usermod -aG docker vagrant
