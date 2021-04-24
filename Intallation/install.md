# Install Kubernetes Cluster using kubeadm
setup Kubernetes Version 1.18.5 cluster on CentOS 8.

# Cluster
1 master node

1 worker node

## On both master and worker
```bash
sudo su
yum -y update
yum -y upgrade
yum -y install nano
```

# On Master Node

## add known host on master node
```bash
nano /etc/hosts
$masterip master
$worker1ip worker
```

# Both Master and Worker Node
## Disable Firewall
```bash
systemctl disable firewalld; systemctl stop firewalld
```
## disable swap and SELinux
```bash
swapoff -a; sed -i '/swap/d' /etc/fstab
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
```
## Update iptables
Update sysctl settings for Kubernetes networking
```bash
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```
## Install docker engine
```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce --nobest
systemctl enable --now docker
```
check docker's status
```bash
systemctl status docker
```
## Kubernetes Setup
Add yum repository
```bash
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```
## Install Kubernetes components
```bash
yum install -y kubeadm-1.18.5-0 kubelet-1.18.5-0 kubectl-1.18.5-0
Enable and Start kubelet service
systemctl enable --now kubelet
```

# On Master node
Initialize Kubernetes Cluster
```bash
kubeadm init --apiserver-advertise-address=$ipaddr --pod-network-cidr=10.20.0.0/16
```
- change your $ipaddr with your master's ip address 
- --pod-network-cidr is optionally, in this case I use 10.20.0.0/16 as pod subnet

## Cluster join command
```bash
kubeadm token create --print-join-command
```
copy the token and paste to both worker, so the worker can join the cluster

## Setting the cluster config
To be able to run kubectl commands as non-root user, exit the root user
```bash
exit
```
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
## Deploy flannel network
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

# On Worker Node
## Join the cluster

Use the output from kubeadm token create command in previous step from the master node and run here.

## Verifying the cluster (On Master Node)
Get Nodes status
```bash
kubectl get nodes
```
congratulations!

## Clone Adaptive's repository
```bash
sudo yum -y install git #install git
git clone https://github.com/adaptivenetlab/kubernetes.git #clone repo
```
Source: just me and opensource