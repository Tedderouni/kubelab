# kubelab

A simple lab using [Vagrant](https://www.vagrantup.com/) and [Virtualbox](https://www.virtualbox.org/) to learn to setup and manage a Kubernetes environment based on [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/).

## Requirements:

Vagrant: https://www.vagrantup.com/downloads

Virtualbox: https://www.virtualbox.org/wiki/Downloads

The Vagrant images are based on [Ubuntu Bionic64](https://app.vagrantup.com/ubuntu/boxes/bionic64). There's no real preference for Ubuntu besides me wanting to use it.  Please feel free to refer to the [Kubeadm documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl) for instrucions on installing on other Linux distributions.

## Clone and Install

```Bash
git clone https://github.com/james-daniels/kubelab.git

cd kubelab
```

Edit the Vagrantfile to suit your resource requirements.  In this configuration, there's a 1 master, 2 worker node cluster.

```Ruby
MASTER_CPU = 2
MASTER_RAM = 2048

WORKER_CPU = 4
WORKER_RAM = 4096

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
```

Once the resource configuration has been set, bring up the Vagrant environment

```Bash
vagrant up
```

## Login to Master Node

```Bash
vagrant ssh master

sudo kubectl get nodes -o wide
```

For those of you not interested in typing sudo all of the time. You can run the following command to configure the kubectl config for the current user.

```Bash
/vagrant/installKubernetes.sh user

kubectl get nodes -o wide
```

### Login to Worker Nodes (Optional)

```Bash
vagrant ssh worker1
```