# Create On Premist Kubernets Cluster with virtualbox
1 master node

2 worker node

Network VM di virtualbox menggunakan adapter NAT dan Host Only
# Konfigurasi environtment
# Master Node 
2 GB RAM

hostname = master

ip address = 192.168.56.10 #pastikan menggunakan range ip dalam network host-only

```bash
sudo apt-get update
sudo apt-get upgrade
```
## A. Konfigurasi hostname
```bash
sudo nano /etc/hostname
```
ubah adaptivenetlab menjadi master

## B. Konfigurasi IP address
```bash
sudo nano /etc/netplan/50-cloud-init.yaml 
```
isikan dengan : 
```bash
network:
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            dhcp4: no
            addresses: [192.168.56.10/24]
    version: 2
```
lalu apply konfigurasi dengan :
```bash 
sudo netplan apply
```
## Restart VM 
klik menu machine > reset

# Worker Node 1
1 GB RAM

hostname = worker1

ip address = 192.168.56.11 #pastikan menggunakan range ip dalam network host-only

```bash
sudo apt-get update
sudo apt-get upgrade
```
## A. Konfigurasi hostname
```bash
sudo nano /etc/hostname
```
ubah adaptivenetlab menjadi worker1

## B. Konfigurasi IP address
```bash
sudo nano /etc/netplan/50-cloud-init.yaml 
```
isikan dengan : 
```bash
network:
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            dhcp4: no
            addresses: [192.168.56.11/24]
    version: 2
```
lalu apply konfigurasi dengan :
```bash 
sudo netplan apply
```
## Restart VM 
klik menu machine > reset

# Worker Node 2
1 GB RAM

hostname = worker1

ip address = 192.168.56.12 #pastikan menggunakan range ip dalam network host-only

```bash
sudo apt-get update
sudo apt-get upgrade
```
## A. Konfigurasi hostname
```bash
sudo nano /etc/hostname
```
ubah adaptivenetlab menjadi worker2

## B. Konfigurasi IP address
```bash
sudo nano /etc/netplan/50-cloud-init.yaml 
```
isikan dengan : 
```bash
network:
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            dhcp4: no
            addresses: [192.168.56.12/24]
    version: 2
```
lalu apply konfigurasi dengan :
```bash 
sudo netplan apply
```
## Restart VM 
klik menu machine > reset

# Konfigurasi host di master node
```bash
sudo nano /etc/hosts
```
tambahkan di line paling bawah dengan :
```bash
192.168.56.10 master.example.com master
192.168.56.11 worker1.example.com worker1
192.168.56.11 worker2.example.com worker2
```
test konektivitas dengan ping worker1 dan worker2
```bash
ping worker1
ping worker2
```
pastikan sudah terhubung satu sama lain.

# Installasi Kubernetes

## Master & worker
## Disable Firewall

```bash
ufw disable
swapoff -a; sed -i '/swap/d' /etc/fstab
```
## Update sysctl settings for Kubernetes networking

```bash
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```
# Install docker engine
```bash
apt-get update && apt-get install -y \
apt-transport-https ca-certificates curl software-properties-common gnupg2
```
## Add Docker’s official GPG key:
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
```

## Add the Docker apt repository:
```bash
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
 ```
## Install Docker CE
```bash
apt-get update && apt-get install -y \
  containerd.io=1.2.13-2 \
  docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
```
 
## Set up the Docker daemon
```bash
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
```

```bash
mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker
```

# Kubernetes Setup
## Add Apt repository
```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
```

## Install Kubernetes components
```bash
apt update && apt install -y kubeadm kubelet kubectl
```

# On Master
## Initialize Kubernetes Cluster
Update the $ipaddr with the ip address of master

```bash
kubeadm init --apiserver-advertise-address=$ipaddr --pod-network-cidr=192.168.0.0/16
```

## Deploy flannel network
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

## Cluster join command
```bash
kubeadm token create --print-join-command
```

# On Kworker
## Join the cluster
Use the output from kubeadm token create command in previous step from the master server and run here on all worker node.

# Verifying the cluster
```bash 
kubectl get nodes
```

Source: just me and opensource github