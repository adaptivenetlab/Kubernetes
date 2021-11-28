# Set Up MetalLB for Bare Metal Kubernetes Cluster

## [METALLB](https://metallb.universe.tf/)
MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.

**Deploy METALLB on Kubernetes**
```bash
kubectl apply -f namespace.yaml
kubectl apply -f metallb.yaml
```
## On first install only
```bash
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
```

## Layer 2 Configuration
change adresses with usable ip from your network ( you can check from ip network of your master node )
```bash
kubectl apply -f cm-l2.yaml
```

## Verify that metallb has successfully deployed
```bash
kubectl get all -n metallb-system
```
you can see there are 3 pods running, 1 controller and 2 speakers.


# Troubleshoot
Jika metallb tidak assign IP secara otomatis, maka terjadi ketidaksesuaian antara flannel network dan subnet. untuk mengatasinya, kita bisa mengubah flannel network agar sama seperti flannel subnet

### /var/run/flannel/subnet.env

```bash 
FLANNEL_NETWORK=20.30.0.0/16
FLANNEL_SUBNET=20.30.0.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
```
pastikan FLANNEL_SUBNET sesuai dengan FLANNEL_NETWORK

jika tidak sesuai maka apply ulang [kubeflannel.yaml](./kube-flannel.yaml) dengan mengganti value network dengan ip network yang sesuai 
```bash
net-conf.json: |
    {
      "Network": "20.30.0.0/16",
      "Backend": {
        "Type": "vxlan"
      }
    }
```

# [Source](https://metallb.universe.tf/installation/)
```bash
https://metallb.universe.tf/installation/
```