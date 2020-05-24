BOX_IMAGE = "ubuntu/bionic64"
NODE_COUNT = 2

Vagrant.configure("2") do |config|

  config.vm.define "master", primary: true do |kubeconfig|
    kubeconfig.vm.box = BOX_IMAGE
    kubeconfig.vm.hostname = "master"
    kubeconfig.vm.network "private_network", type: "dhcp"
    kubeconfig.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = 2048
    end
    kubeconfig.vm.provision "shell", inline: "sudo /vagrant/installKubernetes.sh master"
  end

  (1..NODE_COUNT).each do |i|
    config.vm.define "worker#{i}" do |kubeconfig|
      kubeconfig.vm.box = BOX_IMAGE
      kubeconfig.vm.hostname = "worker#{i}"
      kubeconfig.vm.network "private_network", type: "dhcp"
      kubeconfig.vm.provider "virtualbox" do |vb|
        vb.cpus = 4
        vb.memory = 4096
      end
      kubeconfig.vm.provision "shell", inline: "sudo /vagrant/installKubernetes.sh worker"
    end
  end

  config.vm.box_check_update = false
end
