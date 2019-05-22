# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # documentation: https://docs.vagrantup.com

  # boxes at https://atlas.hashicorp.com/search
  config.vm.box = "ubuntu/bionic64"

  config.ssh.forward_agent = true

  # https://www.vagrantup.com/docs/vagrantfile/machine_settings.html#config-vm-hostname
  config.vm.hostname = "dockerbox"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # https://www.vagrantup.com/docs/synced-folders/
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # https://www.vagrantup.com/docs/virtualbox/
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "35"]
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.customize ["modifyvm", :id, "--cpus", "2"]
    v.customize ["modifyvm", :id, "--name", "dockerbox"]
  end

  # https://www.vagrantup.com/docs/provisioning/
  config.vm.provision "file", source: "~/.ssh", destination: "/tmp/.ssh"
  config.vm.provision "file", source: "./samba/shared_smb.conf.dist", destination: "/tmp/shared_smb.conf.dist"
  config.vm.provision "shell", path: "./provision.sh"
end
