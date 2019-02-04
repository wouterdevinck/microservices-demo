#!/usr/bin/env bash
set -e

SUBSCRIPTION="Wouter"
RESOURCE_GROUP="amsterdam"
LOCATION="westeurope"
NAME="cluster"
VERSION="1.11.5"
INGRESS_COUNT="2"
NODE_COUNT="1"
NODE_SIZE="Standard_DS1_v2"

function printUsage {
  echo "Usage: $0 login|create|configure|dashboard|delete"
  echo "   login     - Login to Azure."
  echo "   create    - Create Kubernetes cluster."
  echo "   configure - Configure the Kubernetes cluster."
  echo "   dashboard - Open the Kubernetes dashboard."
  echo "   delete    - Delete Kubernetes cluster."
  echo ""
}

function login {
  az login
  az account set -s $SUBSCRIPTION
}

function create {

  # Create resource group
  az group create --name $RESOURCE_GROUP --location $LOCATION

  # Create AKS cluster
  az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $NAME \
    --node-count $NODE_COUNT \
    --node-vm-size $NODE_SIZE \
    --kubernetes-version $VERSION \
    --generate-ssh-keys

}

function configure {

  # Configure kubectl with cluster credentials
  az aks get-credentials --resource-group $RESOURCE_GROUP --name $NAME

  # Configure roles, service accounts, namespaces, etc.
  kubectl create -f rbac.yaml

  # Install helm tiller on the cluster
  export TILLER_NAMESPACE=kube-system
  helm init --service-account tiller --tiller-namespace kube-system 
  until helm version
  do
    sleep 5
  done

  # Install nginx ingress - this will also create an Azure Loadbalancer and Public IP
  helm install stable/nginx-ingress --namespace kube-system \
    --set controller.replicaCount=$INGRESS_COUNT
 
  # Install and configure cert-manager
  helm install stable/cert-manager \
    --namespace kube-system \
    --set ingressShim.defaultIssuerName=letsencrypt-prod \
    --set ingressShim.defaultIssuerKind=ClusterIssuer \
    --version v0.5.2
  kubectl apply -f cert.yaml

  # TODO (manual for now):
  # Point an A record for *.tasklist.nl to the public IP created above

}

function dashboard {
  # az aks browse --resource-group $RESOURCE_GROUP --name $NAME
  kubectl port-forward `kubectl get pods --namespace kube-system --output name --selector k8s-app=kubernetes-dashboard` 9090:9090 --namespace kube-system
}

function delete {
  az group delete --name $RESOURCE_GROUP --yes
}

case $1 in
"login")
  login
  ;;
"create")
  create
  ;;
"configure")
  configure
  ;;
"dashboard")
  dashboard
  ;;
"delete")
  delete
  ;;
*)
  printUsage
  ;;
esac
