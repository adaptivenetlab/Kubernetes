# MongoDB on Kubernetes
> MongoDB is a source-available cross-platform document-oriented database program. Classified as a NoSQL database program, MongoDB uses JSON-like documents with optional schemas. MongoDB is developed by MongoDB Inc. and licensed under the Server Side Public License.

### To run mongoDB on kubernetes, we use statefulset because it has persistent network identity.

## Check storage class
```bash
kubectl get sc
```
note the storageclass, we'll use it later

## Create mongoDB statefulset
first, choose the number of replica. in this case we use 2 replicas for high availibility.

```bash
spec:
  serviceName: mongodb-service
  replicas: 2
```
specify storageclass for volume claim template
```bash
  volumeClaimTemplates:
  - metadata:
      name: mongodb-persistent-storage-claim
      annotations:
        volume.beta.kubernetes.io/storage-class: "default" #CHANGE THIS VALUE WITH YOUR STORAGE CLASS
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi #YOU CAN CHANGE DEPENDS ON YOUR NEEDS
```
### **Apply the manifest**
```bash
kubectl apply -f mongodb-sts.yaml
```
check if statefulset is already running 
```bash
kubectl get sts
kubectl get pod
```
## Initiates a replica set
```bash
kubectl exec -ti mongo-0 bash

root@mongo-0:~$ mongo

mongo> rs.initiate({ _id: "MainRepSet", version: 1, 
members: [ 
 { _id: 0, host: "mongod-0.mongodb-service.customer.svc.cluster.local:27017" }, 
 { _id: 1, host: "mongod-1.mongodb-service.customer.svc.cluster.local:27017" }]});

mongo> rs.status();
```
if you have more than 2 replicas, you must add another host to members' array
### Create User and Password for mongoDB admin
```bash
mongo> db.getSiblingDB("admin").createUser({
    user : "mongouser",
    pwd  : "mongopassword",
    roles: [ { role: "root", db: "admin" } ]
});
```

## Create mongodb Headless-Service
```bash
kubectl apply -f mongodb-headless-svc.yaml
```
## Service Discovery
```bash
kubectl run utils -ti --image arunvelsriram/utils bash

utils@root:~$ nslookup mongodb-service.default.svc.cluster.local
```
now, you can access **mongodb-service.default.svc.cluster.local:27017** from inside of kubernetes cluster.

### Monitoring via Datagrip
```bash
kubectl port-forward mongo-0 27017:27017
```
now, you can access mongo-0 from your localhost port 27017 for monitoring!

# [Source](https://deeptiman.medium.com/mongodb-statefulset-in-kubernetes-87c2f5974821)
