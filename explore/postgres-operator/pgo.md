# CrunchData for Postgress Operator
in this lab, we looking for HA postgress cluster using PGO by Crunchy Data

## Install the PostgreSQL Operator
```bash
kubectl create namespace pgo
kubectl apply -f postgres-operator.yaml
```
This will launch the pgo-deployer container that will run the various setup and installation jobs. This can take a few minutes to complete depending on your Kubernetes cluster.

## Install pgo client   
```bash
curl https://raw.githubusercontent.com/CrunchyData/postgres-operator/v4.6.2/installers/kubectl/client-setup.sh > client-setup.sh
chmod +x client-setup.sh
./client-setup.sh
```

This will download the pgo client and provide instructions for how to easily use it in your environment. It will prompt you to add some environmental variables for you to set up in your session, which you can do with the following commands:

```bash
export PGOUSER="${HOME?}/.pgo/pgo/pgouser"
export PGO_CA_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_KEY="${HOME?}/.pgo/pgo/client.key"
export PGO_APISERVER_URL='https://127.0.0.1:8443'
export PGO_NAMESPACE=pgo
```
If you wish to permanently add these variables to your environment, you can run the following:
```bash
cat <<EOF >> ~/.bashrc
export PGOUSER="${HOME?}/.pgo/pgo/pgouser"
export PGO_CA_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_CERT="${HOME?}/.pgo/pgo/client.crt"
export PGO_CLIENT_KEY="${HOME?}/.pgo/pgo/client.key"
export PGO_APISERVER_URL='https://127.0.0.1:8443'
export PGO_NAMESPACE=pgo
EOF

source ~/.bashrc
```
### Check Postgres Operator
```bash
kubectl -n pgo get deployments
```
```bash
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
postgres-operator   1/1     1            1           16h
```
Next, see if the Pods that run the PostgreSQL Operator are up and running:
```bash
kubectl get pods -n pgo
```
If successful, you should see output similar to this:
```bash
NAME                                READY   STATUS    RESTARTS   AGE
postgres-operator-56d6ccb97-tmz7m   4/4     Running   0          2m
```
## Expose pgo-api server
1. Use Port-forwaring 
```bash
kubectl -n pgo port-forward svc/postgres-operator 8443:8443
```
or

2. edit the service type
```bash
kubectl edit svc postgres-operator -n pgo
```
replace the type of service from ClusterIP to LoadBalancer

## Check that you can commicate with pgo api-server
```bash
pgo version
```