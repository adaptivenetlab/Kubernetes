# Install Kubernetes Cluster using kubeadm
setup Kubernetes Version 1.18.5 cluster on CentOS 7.

# Create On Premist Kubernets Cluster with virtualbox
1 master node

2 worker node

Network VM di virtualbox menggunakan adapter Host Only dan NAT 
# Konfigurasi environtment
# Master Node 
2 GB RAM

2 vcpu

hostname = master

ip address = 192.168.56.200

```bash
sudo su
yum -y update 
yum -y upgrade
yum -y install nano 
```
## A. Konfigurasi Hostname
```bash
nano /etc/hostname
```
ubah adaptive menjadi master

## B. Konfigurasi IP Address
```bash
nano /etc/sysconfig/network-scripts/ifcfg-enp0s3
```
ubah menjadi IPADDR=192.168.56.200

## Restart VM

```bash
sudo reboot 
```

# Worker Node 1 
1 GB RAM

1 vcpu

hostname = worker1

ip address = 192.168.56.201

```bash
sudo su
yum -y update 
yum -y upgrade
yum -y install nano 
```
## A. Konfigurasi Hostname
```bash
nano /etc/hostname
```
ubah adaptive menjadi worker1

## B. Konfigurasi IP Address
```bash
nano /etc/sysconfig/network-scripts/ifcfg-enp0s3
```
ubah menjadi IPADDR=192.168.56.201

## Restart VM

```bash
sudo reboot 
```

# Worker Node 2 
1 GB RAM

1 vcpu

hostname = worker2

ip address = 192.168.56.202

```bash
sudo su
yum -y update 
yum -y upgrade
yum -y install nano 
```
## A. Konfigurasi Hostname
```bash
nano /etc/hostname
```
ubah adaptive menjadi worker2

## B. Konfigurasi IP Address
```bash
nano /etc/sysconfig/network-scripts/ifcfg-enp0s3
```
ubah menjadi IPADDR=192.168.56.202

## Restart VM

```bash
sudo reboot 
```

# On Master Node

## add known host on master node
```bash
nano /etc/hosts
192.168.56.200 master
192.168.56.201 worker1
192.168.56.202 worker2
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
yum install -y docker-ce-19.03.12 
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
```
## Enable and Start kubelet service
```bash
systemctl enable --now kubelet
```

# On Master node
Initialize Kubernetes Cluster
```bash
kubeadm init --apiserver-advertise-address=$ipaddr --pod-network-cidr=10.20.0.0/16
```
- change your $ipaddr with your master's ip address (192.168.56.200)
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

# On Worker Node 1 and Worker Node 2
## Join the cluster

Use the output from kubeadm token create command in previous step from the master node and run here.

## Verifying the cluster (On Master Node)
Get Nodes status
```bash
kubectl get nodes
```
congratulations!

Source: just me and opensource