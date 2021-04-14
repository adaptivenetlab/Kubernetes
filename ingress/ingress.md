# Configure Ingress on Bare Metal Cluster
You must have metallb on your cluster for provisioning loadbalancer ip

## Deploy NGINX Ingress Controller with Helm
must have helm installed on your machine
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```
save the value of ingress yaml to /tmp
```bash
helm show values ingress-nginx/ingress-nginx > /tmp/ingress-nginx.yaml
vi /tmp/ingress-nginx.yaml
```
edit $ from false to true
```bash
hostNetwork: true #$ false to true

  ## Use host ports 80 and 443
  ## Disabled by default
  ##
  hostPort:
    enabled: true #$ false to true
    ports:
      http: 80
      https: 443
```
## Create Ingress Namespace
```bash
kubectl create ns ingress-nginx
kubectl get ns
```
## Apply helm package
```bash
helm install myingress ingress-nginx/ingress-nginx -n ingress-nginx --values /tmp/ingress-nginx.yaml
```
## Verify that package has sucessfully deployed
```bash
helm list -n ingress-nginx
kubectl get all -n igress-nginx
```
note the external ip that we can use for access the cluster from outside the cluster

# Test Deployment
## Deployment with Service
```bash
kubectl apply -f deployments/main-nginx.yaml
kubectl apply -f deployments/blue-nginx.yaml
kubectl apply -f deployments/green-nginx.yaml
```
## Apply Nginx Rule
- Path Based
```bash
kubectl apply -f path-based.yaml
```
or
- Name Based
```bash
kubectl apply -f name-based.yaml
```

## Add The Record 
```bash 
vi /etc/hosts
```
add ingress ip and local domain that used in nginx rule
```
192.168.0.102 ingress.nathan.local
192.168.0.102 blue.nathan.local
192.168.0.102 green.nathan.local
```
## Access from Browser
depend on your nginx rule
http://ingress.nathan.local/...

**CONGRATULATIONS** you have configured nginx ingress on your cluster!