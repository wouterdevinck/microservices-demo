#!/bin/bash
set -e

# Creates an account for each group on bastion and on the cluster.

# Get kubernetes API server url from kubectl configuration
URL=`kubectl config view -o json | jq -r .clusters[0].cluster.server`

for i in {01..10}
do

  export GROUP="group$i"
  PWD=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10`
  echo "Creating account $GROUP with password $PWD"

  # Create user on bastion
  sudo adduser --disabled-password --gecos "" $GROUP
  echo "$GROUP:$PWD" | sudo chpasswd

  # Add bastion user to docker group
  sudo usermod -aG docker $GROUP

  # Create namespace, service account, role and role binding on cluster
  envsubst < group.yaml.tmpl > group.yaml
  kubectl apply -f group.yaml
  rm group.yaml

  # Paths to config files for user on bastion
  FIN_PATH="/home/$GROUP/.kube"
  TMP_PATH="tmp"
  CRT_FILE="ca.crt"
  CON_FILE="config"
  mkdir -p $TMP_PATH

  # Get secrets for service account from cluster
  SECRETID=`kubectl get secrets --namespace $GROUP --output name | grep $GROUP`
  TOKEN=`kubectl get $SECRETID -o jsonpath={.data.token}  --namespace $GROUP | base64 -d`
  kubectl get $SECRETID -o "jsonpath={.data.ca\.crt}" --namespace $GROUP | base64 -d > "$TMP_PATH/$CRT_FILE"

  # Configure kubectl on bastion with secrets for this user
  kubectl --kubeconfig="$TMP_PATH/$CON_FILE" config set-credentials user --token=$TOKEN
  kubectl --kubeconfig="$TMP_PATH/$CON_FILE" config set-cluster cluster --server=$URL --certificate-authority="$TMP_PATH/$CRT_FILE"
  kubectl --kubeconfig="$TMP_PATH/$CON_FILE" config set-context cluster --cluster=cluster --user=user --namespace=$GROUP
  kubectl --kubeconfig="$TMP_PATH/$CON_FILE" config use-context cluster

  # Move files into bastion user's home
  sudo mkdir -p $FIN_PATH
  sudo mv "$TMP_PATH/$CRT_FILE" "$FIN_PATH/$CRT_FILE"
  sudo mv "$TMP_PATH/$CON_FILE" "$FIN_PATH/$CON_FILE"
  sudo chown $GROUP "$FIN_PATH/$CRT_FILE"
  sudo chown $GROUP "$FIN_PATH/$CON_FILE"
  sudo chmod 600 "$FIN_PATH/$CRT_FILE"
  sudo chmod 600 "$FIN_PATH/$CON_FILE"
  rm -rf $TMP_PATH

done
