# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don"t touch unless you know what you"re doing!
VAGRANTFILE_API_VERSION = "2"

def attach_hdd(vm, port, size)
  hdd_path = ".vagrant/disks/data#{port}.vdi"
  vm.customize ["createhd", "--filename", hdd_path, "--size", size]
  vm.customize ["storageattach", :id, "--storagectl", "SATAController", "--port", port, "--device", 0, "--type", "hdd", "--medium", hdd_path]
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |vm|
    vm.customize ["modifyvm", :id, "--cpus", 2, "--memory", "4096"]
    attach_hdd(vm, 1, 16 * 1024)
    attach_hdd(vm, 2, 16 * 1024)
    attach_hdd(vm, 3, 16 * 1024)
  end

  config.vm.provision "shell", path: "bin/init.sh"
end
