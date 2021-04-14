# Set Up MetalLB for Bare Metal Kubernetes Cluster

```bash
kubectl apply -f namespace.yaml
kubectl apply -f metallb.yaml
```
## On first install only
```bash
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
```

## Layer 2 Configuration
change adresses with usable ip from your network (you can check from ip network of your master node)
```bash
kubectl apply -f cm-l2.yaml
```

## Verify that metallb has successfully deployed
```bash
kubectl get all -n metallb-system
```
you can see there are 4 pods running, 1 controller and 3 speakers.

source : https://metallb.universe.tf/installation/