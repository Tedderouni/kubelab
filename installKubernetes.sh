#!/bin/bash
###############################################
# installKubernetes.sh
# usage:
# For worker nodes: ./installKubernetes.sh worker
# For master nodes: ./installKubernetes.sh master
###############################################

CIDR=$(ip a show enp0s8 | grep global | awk '{print $2}')
IP=${CIDR::-3}


setupKubectl(){

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  return
}

if [ "$1" == "user" ]; then
  setupKubectl
  exit
fi


setupMaster(){
  ### Initiate Kubeadm
  echo "Initiate Kubeadm cluster..." && sleep 2
  [ -f /vagrant/kubemasterOutput.txt ] && echo > /vagrant/kubemasterOutput.txt

  ### For Vagrant/Virtualbox environments you need to set --apiserver-advertise-address=$IP
  kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$IP | tee -a /vagrant/kubemasterOutput.txt

  setupKubectl

  ### Install network add-on for Calico
  echo "Install network add-on for Calico..." && sleep 2
  kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml

  tail -2 /vagrant/kubemasterOutput.txt > /vagrant/setupWorker.sh && chmod +x /vagrant/setupWorker.sh

  kubectl completion bash > /etc/bash_completion.d/kubectl

  return
}


setupWorker(){
  ### Initiate Kubeadm join to cluster
  echo "Initiate Kubeadm join to cluster..." && sleep 2
  /vagrant/setupWorker.sh

  ### Related to --apiserver-advertise-address parameter on master node.
  ### This allows the worker node to avertise the correct IP.
  echo Environment="'KUBELET_EXTRA_ARGS=--node-ip=$IP'" | tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

  systemctl daemon-reload && systemctl restart kubelet

  return
}


### Install Docker CE
### Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
echo "Update and install Docker CE..." && sleep 2
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg-agent

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

### Add Docker apt repository.
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

### Install Docker CE
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
#apt-get update && apt-get install -y containerd.io=1.2.13-1 docker-ce=5:19.03.8~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.8~3-0~ubuntu-$(lsb_release -cs)

### Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

### Restart docker.
systemctl daemon-reload

systemctl restart docker

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

### Install Kubeadm/Kublet
echo "Install Kubeadm/Kublet..." && sleep 2
sudo apt-get update && sudo apt-get install -y apt-transport-https curl etcd-client

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl


if [ "$1" == "master" ]; then
  setupMaster
  exit
fi

if [ "$1" == "worker" ]; then
  setupWorker
  exit
fi