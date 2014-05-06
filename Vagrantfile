# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Box's configurations
  # ====================
  config.vm.box = "deb64"
  config.vm.box_url = "https://googledrive.com/host/0B83ZToJ3fGtDVC1DeVVzc3lkc0U/debian-7.5.0-amd64_virtualbox.box"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--name", "Ro0ny's box"]
  end

  # Network's configurations
  # ========================
  config.ssh.forward_agent = true
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.network "forwarded_port", guest: 80, host: 8000

  # Folders sync configuration
  # ==========================
  config.vm.synced_folder "~/.ssh", "/root/.ssh" # sync ssh's folder

  # Provision's configuration
  # =========================
  config.vm.provision :shell, :path => "./provision.sh"
end
