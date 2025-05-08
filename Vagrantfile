# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"

  # Define control node
  config.vm.define "ctrl-node" do |ctrl_node|
    ctrl_node.vm.hostname = "ctrl"
    ctrl_node.vm.network "private_network", ip: "192.168.56.100"

    # Set memory to 4GB and CPU to 1
    ctrl_node.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 1
    end
  end

  # Define first worker
  config.vm.define "node-1" do |node_1|
    node_1.vm.hostname = "node-1"
    node_1.vm.network "private_network", ip: "192.168.56.101" 

    # Set memory & CPU
    node_1.vm.provider "virtualbox" do |v|
      v.memory = 6144
      v.cpus = 2
    end
  end

  # Define second worker
  config.vm.define "node-2" do |node_2|
    node_2.vm.hostname = "node-2"
    node_2.vm.network "private_network", ip: "192.168.56.102" 

    # Set memory & CPU
    node_2.vm.provider "virtualbox" do |v|
      v.memory = 6144
      v.cpus = 2
    end
  end
end
