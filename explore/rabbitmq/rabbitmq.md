# Rabbitmq on Kubernetes
## Apply Rabbitmq Operator
```bash
kubectl apply -f https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
```
### Check if all operator component ready
```bash
kubectl get all -o wide -n rabbitmq-system
```
after all operator component ready, next step is deploy rabbitmq with headless service 
## Create rabbitq namespace
```bash
kubectl create ns rabbitmq
```
## Apply rabbitmq manifest
```bash
kubectl apply -f rabbitmq-manifest.yaml
```
## Apply rabbitmq headless service
```bash
kubectl apply -f headless-service.yaml
```
### Check if all rabbitmq component ready
```bash
kubectl get all -o wide -n rabbitmq
```
## Using rabbitmq-perf-test to Run a Functional and Load Test of the Cluster
```bash
kubectl run perf-test --image=pivotalrabbitmq/perf-test -- --uri amqp://default_user_sE5oDdB2zigtXmMAmPZ:QjdMuXFgfQvk1XQaB6hLIXMMHGvAgl8g@rabbitmq-headless.rabbitmq.svc.cluster.local
```
## Check logs
```bash
kubectl logs perf-test
```
## Delete pod 
```bash
kubectl delete pod perf-test
```