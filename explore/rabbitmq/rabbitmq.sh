#!/bin/sh

kubectl apply -f https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
kubectl create ns rabbitmq
kubectl apply -f ./rabbitmq-manifest.yaml
kubectl apply -f ./headless-service.yaml