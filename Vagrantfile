Vagrant.configure("2") do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"

  # Number of worker nodes
  num_workers = 2

  # Variables for ctrl node
  ctrl_cpus = 2
  ctrl_memory = 4096

  # Variables for worker nodes
  worker_memory = 6144
  worker_cpus = 2

  # Network base
  network_base = "192.168.56."

  config.trigger.after :up do |trigger|
    trigger.ruby do
      
      File.open("inventory.cfg", 'w') do |f|
        f.puts "[controller]"
        f.puts "ctrl ansible_host=#{network_base}100"
        f.puts ""
        
        f.puts "[workers]"
        (1..num_workers).each do |i|
          f.puts "node-#{i} ansible_host=#{network_base}10#{i} ansible_user=vagrant"
        end

        f.puts ""
        f.puts "[all:children]"
        f.puts "controller"
        f.puts "workers"
      end
      puts "Inventory file creation succeeded"
    end
  end


  # Open the general setup playbook.
  config.vm.provision :ansible do |a|
    a.playbook = "general.yaml"
    a.extra_vars = {
        num_workers: num_workers
      }
  end

  # Define control node
  config.vm.define "ctrl" do |ctrl_node|
    ctrl_node.vm.hostname = "ctrl"
    ctrl_node.vm.network "private_network", ip: "#{network_base}100"

    # Set memory to 4GB and CPU to 2
    ctrl_node.vm.provider "virtualbox" do |v|
      v.memory = ctrl_memory
      v.cpus = ctrl_cpus
    end

    # Open the control playbook.
    ctrl_node.vm.provision :ansible do |a|
      a.playbook = "ctrl.yaml"
    end
  end

  # Define workers
  (1..num_workers).each do |i|
    # Define first worker
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "#{network_base}10#{i}"

      # Set memory & CPU
      node.vm.provider "virtualbox" do |v|
        v.memory = worker_memory
        v.cpus = worker_cpus
      end

      # Open the node playbook.
      node.vm.provision :ansible do |a|
        a.playbook = "node.yaml"
      end

    end

  end

end