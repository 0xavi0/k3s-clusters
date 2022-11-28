#!/bin/bash

kubectl create namespace cattle-system
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.1

kubectl wait --namespace cert-manager --for=condition=ready pod --all --timeout=30s

echo "Installing rancher...."
helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.xavi-garcia.net --set replicas=1
kubectl -n cattle-system rollout status deploy/rancher


echo "Showing ingress"
kubectl get ingress -A

echo "Bootstrap password"
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'

