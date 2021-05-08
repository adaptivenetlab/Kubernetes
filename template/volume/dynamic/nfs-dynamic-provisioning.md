# Dynamic Provisioning with NFS
We need configure NFS Server, In this case we will use master node as NFS Server.

## Both Master and Worker node
```bash
sudo yum install nfs-utils
```

## Master Node
```bash
mkdir /srv/nfs/kubedata
sudo chown nobody: /srv/nfs/kubedata
```
### Edit exports file
```bash
sudo vi /etc/exports
```
add this configuration on last line 
```bash
/srv/nfs/kubedata   *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure) 
```
Enable nfs-server
```bash 
sudo systemctl enable --now nfs-server
sudo exportfs -rav
sudo showmount -e localhost
```

### Create Namespace

```bash
kubectl create ns nfs-provisioner
```

### Deploy Provisioner and Storage Class
```bash
kubectl apply -f rbac.yaml -n nfs-provisioner
kubectl apply -f deployment.yaml -n nfs-provisioner
kubectl apply -f class.yaml -n nfs-provisioner
```
## Testing The Volume
```bash 
kubectl apply -f test-claim.yaml 
kubectl apply -f test-pod.yaml 
```
### Verify the pod 
```bash
kubectl get pod 
```

dynamic provisioning with nfs was sucessfully!

# Source

https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
