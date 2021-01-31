# AZURE KUBERNETES SERVICE INGRESS WITH SSL
create kubernetes cluster in azure

## Clone This Repository
```bash
git clone https://github.com/adaptivenetlab/kubernetes.git
cd /kubernetes/aks/
```
# Ingress Controller
## Create a namespace for your ingress resources
```bash
kubectl create namespace ingress
```

## Add the ingress-nginx repository
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

## Use Helm to deploy an NGINX ingress controller
```bash
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
```
Check External IP
```bash
kubectl get services -n ingress
```

## Add your external ip to dns management with A record ex: ingress.nathann.site

# Cert Manager
## Label the ingress-basic namespace to disable resource validation
```bash
kubectl label namespace ingress cert-manager.io/disable-validation=true
```

## Add the Jetstack Helm repository
```bash
helm repo add jetstack https://charts.jetstack.io
```

## Update your local Helm chart repository cache
```bash
helm repo update
```

## Install the cert-manager Helm chart
```bash
helm install cert-manager jetstack/cert-manager \
  --namespace ingress \
  --version v0.16.1 \
  --set installCRDs=true \
  --set nodeSelector."kubernetes\.io/os"=linux \
  --set webhook.nodeSelector."kubernetes\.io/os"=linux \
  --set cainjector.nodeSelector."kubernetes\.io/os"=linux
```

## Create a CA cluster issuer
change $your-email to your active email
```bash
kubectl apply -f cluster-issuer.yaml
```

# Run Demo Applications
```bash
kubectl apply -f deployments/main-nginx.yaml --namespace ingress
kubectl apply -f deployments/blue-nginx.yaml --namespace ingress
kubectl apply -f deployments/green-nginx.yaml --namespace ingress
```

# Apply Ingress Rule (Path Based Routing)
```bash
kubectl apply -f ingress-path.yaml --namespace ingress
```

## Check the Certificate
```bash
kubectl get certificate --namespace ingress
```

## and now open your domain and check ssl connection!

https://docs.microsoft.com/en-us/azure/aks/ingress-basic

source : https://docs.microsoft.com/en-us/azure/aks/ingress-tls