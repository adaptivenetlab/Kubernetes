# Installing Prometheus with Helm
must have helm installed on your machine
## Create Prometheus namespace
```bash
kubectl create namespace prometheus
```
## Add Repo and Install the charts
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-release bitnami/kube-prometheus -n prometheus
```
## Verify the installation
```bash
helm list -n prometheus
kubectl get all -n prometheus
kubectl get svc -n prometheus
```
## Change Prometheus service from ClusterIP to LoadBalancer
```bash
kubectl edit service my-release-kube-prometheus-prometheus -n prometheus
```
type: ClusterIP  to => type: LoadBalancer

## Check External IP from prometheus service
```bash
kubectl get svc -n prometheus 
```
note external ip and try to access from browser
```bash
<external-ip>:9090
```

# Set Up Grafana
I suggest to install grafana on your local workspace, so you just only import prometheus data source $external-ip:9090 to grafana monitoring dashboard

## *[ OPTIONAL ]*
for security, better if we don't expose prometheus' port into internet because everyone can access the prometheus by external IP and port.

for solution, you **don't** need to change type of prometeus service from ClusterIP to LoadBalancer, just use port-forward from pod inside kube cluster to your localhost port.

```bash
kubectl port-forward -n prometheus ${PROMETHEUS_POD_NAME} 9090:9090
```
change *{PROMETHEUS_POD_NAME}* with your prometheus pod name

you can check with ```kubectl get pod -n prometheus```

>### Now you can access prometheus from your localhost:9090 without expose it to internet.