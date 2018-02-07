#!/bin/bash
set -e

CLUSTER="k8s.me"

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
CRED_DIR="$SCRIPT_DIR/../.credentials"

function printUsage {
  echo "Usage: kube.sh login|logout|publish|deploy|destroy"
  # TODO more info
}

case $1 in

"login") 

  # 1. Ask for username/password
  printf "Username: "
  read USERNAME
  printf "Password: "
  read -s PASSWORD
  printf "\n"

  # 2. Store credentials
  rm -rf $CRED_DIR || true
  mkdir $CRED_DIR
  echo "$USERNAME:$PASSWORD" > $CRED_DIR/account

  # 3. Get certificate, token, etc. from bastion
  sshpass -p "$PASSWORD" scp $USERNAME@bastion.$CLUSTER:$USERNAME.* $CRED_DIR

  # 4. Configure kubectl (to talk to the Kubernetes cluster)
  kubectl config set-cluster $CLUSTER-$USERNAME --embed-certs=true --server=https://api.$CLUSTER/ --certificate-authority=$CRED_DIR/$USERNAME.crt
  kubectl config set-credentials $USERNAME --token=`cat $CRED_DIR/$USERNAME.token`
  kubectl config set-context $USERNAME --cluster=$CLUSTER-$USERNAME --user=$USERNAME --namespace=$USERNAME
  kubectl config use-context $USERNAME

  # 5. Configure docker (to push images to Docker Hub)
  HUB=`cat $CRED_DIR/$USERNAME.hub`
  HUBCRED=(${HUB//:/ })
  echo "${HUBCRED[1]}" | docker login --username ${HUBCRED[0]} --password-stdin

  ;;

"logout")

  # 1. Logout from Kubernetes
  rm -f ~/.kube/config || true

  # 2. Logout from Docker Hub
  docker logout

  # 3. Remove credential from disk
  rm -rf $CRED_DIR || true

  ;;

"publish")

  # TODO

  ;;

"deploy"|"destroy")

  # 1. Load stored credentials
  ACCOUNT=`cat $CRED_DIR/account`
  CRED=(${ACCOUNT//:/ })
  export USERNAME=${CRED[0]}
  export PASSWORD=${CRED[1]}

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
  printUsage
  ;;

esac