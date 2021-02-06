# LAB 1
# Create PV (NFS), Deployment, Expose service NodePort
## clone repo
```bash
https://github.com/adaptivenetlab/kubernetes.git
cd kubernetes-config/lab1
```
## Di node worker, buat direktori /data 
```bash
sudo mkdir /data
```

## Setting Manifest nfs-server
```bash
nano nfs-server.yaml
```
---
    spec:
      nodeSelector: 
        kubernetes.io/hostname: node0

ganti node0 dengan nama host worker (dapat dicek dengan kubectl get nodes) masing-masing.

## Di node master, jalankan file nfs-server.yaml
```bash
kubectl create -f nfs.yaml
kubectl describe deployment nfs-server
kubectl describe services nfs-server
```
* Catat ClusterIP dari nfs-server

## PV Provisioning. Edit IP server dengan ClusterIP nfs-server
```bash
nano pv.yaml
```
.....
  nfs:
    # FIXME: use the right IP
    server: use IP from nfs-server ClusterIP
path: "/exports"
....
## Apply and Check Persistent Volume
```bash
kubectl apply -f pv.yaml
kubectl get pv
```

# Persistent Volume Claim
```bash
kubectl apply -f pvc.yaml
kubectl get pvc
```

## Instal paket nfs-common di semua node 
```bash
sudo yum install -y nfs-utils
```
## Apply Deployment with PVC
```bash
kubectl apply -f deployment.yaml
kubectl get deploy
```
## Expose Deployment dengan Service NodePort

```bash
kubectl apply -f nodeport.yaml
kubectl get svc
```

## tambahkan index.html di folder /data di worker
lakukan di vm worker
```bash
sudo su
echo "<h1>Hello client from kubernetes cluster using PVC :)</h1>" >> /data/index.html
```

## Testing
## open browser
```bash
http://$IPworkernode:32000
```

Source: nolsatuid