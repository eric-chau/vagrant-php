# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Box's configurations
  # ====================
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--name", "devbox-php7"]
  end

  # Network's configurations
  # ========================
  config.ssh.forward_agent = true
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.network "forwarded_port", guest: 80, host: 8000
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Folders sync configuration
  # ==========================
  config.vm.synced_folder "~/.ssh", "/root/.ssh"

  # Provision's configuration
  # =========================
  config.vm.provision :shell, :path => "./provision.sh"
end
