#!/bin/bash
set -e

CLUSTER="k8s.me"

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

case $1 in

"login")

  # 1. Ask for username/password
  printf "Username: "
  read USERNAME
  printf "Password: "
  read -s PASSWORD
  printf "\n"

  # 2. Store credentials
  rm -rf credentials || true
  mkdir credentials
  echo $USERNAME > $SCRIPT_DIR/../credentials/username
  echo $PASSWORD > $SCRIPT_DIR/../credentials/password

  # 3. Get certificate and token from bastion
  sshpass -p $PASSWORD scp $USERNAME@bastion.$CLUSTER:$USERNAME.* ./credentials/

  # 4. Configure kubectl
  kubectl config set-cluster $CLUSTER-$USERNAME --embed-certs=true --server=https://api.$CLUSTER/ --certificate-authority=./credentials/$USERNAME.crt
  kubectl config set-credentials $USERNAME --token=`cat $SCRIPT_DIR/../credentials/$USERNAME.token`
  kubectl config set-context $USERNAME --cluster=$CLUSTER-$USERNAME --user=$USERNAME --namespace=$USERNAME
  kubectl config use-context $USERNAME

  ;;

"deploy"|"destroy")

  # 1. Load stored credentials
  export USERNAME=`cat ./credentials/username`
  export PASSWORD=`cat ./credentials/password`

  # 2. Transform the template by substituting the environment variables
  envsubst < $SCRIPT_DIR/task-app.tmpl > $SCRIPT_DIR/task-app.yaml

  # 3. Deploy/delete this config to/from the Kubernetes cluster
  if [ $1 = "deploy" ]; then
    kubectl apply -f $SCRIPT_DIR/task-app.yaml
  else
    kubectl delete -f $SCRIPT_DIR/task-app.yaml
  fi
  
  # 4. Clean up
  rm $SCRIPT_DIR/task-app.yaml

  ;;

*)
  echo "Usage: kube.sh login|deploy|destroy"
  ;;

esac