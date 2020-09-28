MASTER_CPU = 2
MASTER_RAM = 2048

WORKER_CPU = 2
WORKER_RAM = 2048

WORKER_COUNT = 2

BOX_IMAGE = "ubuntu/bionic64"

Vagrant.configure("2") do |config|

  config.vm.define "master", primary: true do |kubeconfig|
    kubeconfig.vm.box = BOX_IMAGE
    kubeconfig.vm.hostname = "master"
    kubeconfig.vm.network "private_network", type: "dhcp"
    kubeconfig.vm.provider "virtualbox" do |vb|
      vb.cpus = MASTER_CPU
      vb.memory = MASTER_RAM
    end
    kubeconfig.vm.provision "shell", inline: "sudo /vagrant/installKubernetes.sh master"
    kubeconfig.vm.provision "shell", inline: "sudo /vagrant/installHelm.sh"
  end

  (1..WORKER_COUNT).each do |i|
    config.vm.define "worker#{i}" do |kubeconfig|
      kubeconfig.vm.box = BOX_IMAGE
      kubeconfig.vm.hostname = "worker#{i}"
      kubeconfig.vm.network "private_network", type: "dhcp"
      kubeconfig.vm.provider "virtualbox" do |vb|
        vb.cpus = WORKER_CPU
        vb.memory = WORKER_RAM
      end
      kubeconfig.vm.provision "shell", inline: "sudo /vagrant/installKubernetes.sh worker"
    end
  end

  config.vm.box_check_update = false
end
