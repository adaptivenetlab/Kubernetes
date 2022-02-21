## Install Istio

### Download Istio file
```bash
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.9.2
export PATH=$PWD/bin:$PATH
```
### Install the Istio Operator
```bash
istioctl operator init  
kubectl get all -n istio-operator
```
### Apply istio
```bash
kubectl apply -f - <<EOF
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: example-istiocontrolplane
spec:
  profile: demo
EOF
```
### Check if Istio has sucessfully installed
```bash
kubectl get all -n istio-system
```
---

## Monitoring

### Install Prometheus
```bash
kubectl apply -f https://gitlab.com/gilangvperdana/microservices-app-on-k-8-s-with-istio/-/raw/master/addons/prometheus.yaml -n istio-system
```

### Install Grafana (Optional)
```bash
kubectl apply -f https://gitlab.com/gilangvperdana/microservices-app-on-k-8-s-with-istio/-/raw/master/addons/grafana.yaml -n istio-system
```

Change Service Grafana to LoadBalancer:
```bash
kubectl edit svc grafana -n istio-system
```
access `http://<ip-external-service-grafana>:3000`

### Install Kiali
```bash
kubectl apply -f https://gitlab.com/adaptivenetlab/adaptive-network-laboratory-kubernetes-service-mesh-untuk-aplikasi-microservices/-/raw/master/addons/kiali-crd.yaml -n istio-system

kubectl apply -f https://gitlab.com/adaptivenetlab/adaptive-network-laboratory-kubernetes-service-mesh-untuk-aplikasi-microservices/-/raw/master/addons/kiali.yaml -n istio-system
```

Change service to LoadBalancer:
```bash
kubectl edit svc kiali -n istio-system
kubectl get svc kiali -n istio-system
```
access `http://ip_external_kiali:20001`