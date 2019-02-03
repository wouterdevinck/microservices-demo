#!/bin/bash

# Expose the Kubernetes dashboard (deployed by AKS) on the internet, with basic auth.
# Not recommended for production :-)

htpasswd -c ./auth admin
kubectl create secret generic admin --from-file auth --namespace kube-system
kubectl apply -f dash.yaml --namespace kube-system