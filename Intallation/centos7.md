# Install Kubernetes Cluster using kubeadm
setup Kubernetes cluster on CentOS 7.

# Create On Premist Kubernets Cluster with virtualbox
1 master node

2 worker node

Network VM di virtualbox menggunakan adapter Host Only dan NAT 
# Konfigurasi environtment
## Master Node 
2 GB RAM

2 vcpu

hostname = master

ip address = 192.168.56.200

## Worker1 Node 
2 GB RAM

1 vcpu

hostname = master

ip address = 192.168.56.201

## Worker1 Node 
2 GB RAM

1 vcpu

hostname = master

ip address = 192.168.56.201

```bash
sudo yum -y update
```
## set ip on centos
```bash
sudo vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
```

change with your host ip

## add known host on master node
```bash
sudo vi /etc/hosts
192.168.56.200 master
192.168.56.201 worker1
192.168.56.202 worker2
```

# BOTH MASTER AND WORKER
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
kubeadm init --apiserver-advertise-address=$ipaddr --pod-network-cidr=192.168.0.0/16
```
change your $ipaddr with your master's ip address

## Deploy flannel network
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

## Cluster join command
```bash
kubeadm token create --print-join-command
```
To be able to run kubectl commands as non-root user, exit the root user
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

# On worker node
Join the cluster

Use the output from kubeadm token create command in previous step from the master server and run here.

## Verifying the cluster
Get Nodes status
```bash
kubectl get nodes
```
congratulations!

Source: just me and opensource