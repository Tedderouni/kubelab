# kubelab

A simple lab to using [Vagrant](https://www.vagrantup.com/) and [Virtualbox](https://www.virtualbox.org/) to learn to setup and manage a Kubernetes environment based on [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/).

## Requirements:

Vagrant: https://www.vagrantup.com/downloads

Virtualbox: https://www.virtualbox.org/wiki/Downloads

The Vagrant images are based on [Ubuntu Ironic64](https://app.vagrantup.com/ubuntu/boxes/bionic64). There's no real preference for Ubuntu besides me wanting to use it.  Please feel free to refer to the [Kubeadm documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl) for instrucions on installing on other Linux distributions.

## Clone and Install

```Bash
git clone https://github.com/james-daniels/kubelab.git

cd kubelab

vagrant up

```

## Login to Master Node

```Bash
vagrant ssh master

sudo kubectl get nodes -o wide
```

For those of you not interested in typing sudo all of the time. You can run the following command to copy configure the kubectl config for the current user.

```Bash
/vagrant/installKubernetes.sh user

kubectl get nodes -o wide
```

### Login to Worker Nodes (Optional)

```Bash
vagrant ssh worker1
```