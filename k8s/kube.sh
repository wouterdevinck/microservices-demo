#!/bin/bash
set -e

CLUSTER="k8s.me"   # Domain name of Kubernetes cluster (assumes api.$CLUSER, bastion.$CLUSTER and dashboard.$CLUSTER)
CONFIG="task-app"  # Name of template for Kubernetes yaml (defines services, deployments, etc.)
LIST="images.list" # Name of file with list of images that need to be published to Docker Hub

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
CRED_DIR="$SCRIPT_DIR/../.credentials"

function printUsage {
  echo "Usage: $0 login|logout|publish|deploy|destroy|dashboard"
  echo ""
  echo "   login     - Secure copy secrets from bastion and configures kubectl and docker."
  echo "   logout    - Forget all secrets and unconfigure kubectl and docker."
  echo "   publish   - Publish all docker images to Docker Hub."
  echo "   deploy    - Deploy all services to the Kubernetes cluster."
  echo "   destroy   - Delete all services from the Kubernetes cluster."
  echo "   dashboard - Open the Kubernetes dashboard."
  echo ""
}

case $1 in

"login") 

  # Ask for username/password
  printf "Username: "
  read USERNAME
  printf "Password: "
  read -s PASSWORD
  printf "\n"

  # Store credentials
  rm -rf $CRED_DIR || true
  mkdir $CRED_DIR
  echo "$USERNAME:$PASSWORD" > $CRED_DIR/account

  # Get certificate, token, etc. from bastion
  sshpass -p "$PASSWORD" scp $USERNAME@bastion.$CLUSTER:$USERNAME.* $CRED_DIR

  # Configure kubectl (to talk to the Kubernetes cluster)
  kubectl config set-cluster $CLUSTER-$USERNAME --embed-certs=true --server=https://api.$CLUSTER/ --certificate-authority=$CRED_DIR/$USERNAME.crt
  kubectl config set-credentials $USERNAME --token=`cat $CRED_DIR/$USERNAME.token`
  kubectl config set-context $USERNAME --cluster=$CLUSTER-$USERNAME --user=$USERNAME --namespace=$USERNAME
  kubectl config use-context $USERNAME

  # Configure docker (to push images to Docker Hub)
  HUB=`cat $CRED_DIR/$USERNAME.hub`
  HUBCRED=(${HUB//:/ })
  echo "${HUBCRED[1]}" | docker login --username ${HUBCRED[0]} --password-stdin

  ;;

"logout")

  # Logout from Kubernetes
  rm -f ~/.kube/config || true

  # Logout from Docker Hub
  docker logout

  # Remove credential from disk
  rm -rf $CRED_DIR || true

  ;;

"publish")

  if [ ! -d "$CRED_DIR" ]; then
    echo "Please log in first."
    exit 2
  fi

  # Read username and docker hub username
  ACCOUNT=`cat $CRED_DIR/account`
  CRED=(${ACCOUNT//:/ })
  USERNAME=${CRED[0]}
  HUB=`cat $CRED_DIR/$USERNAME.hub`
  HUBCRED=(${HUB//:/ })
  HUBACCOUNT=${HUBCRED[0]}

  # Load the list of images that need to be pushed to Docker hub
  while IFS='' read -r IMG || [[ -n "$IMG" ]]; do

    # Tag image with unique name and push it to Docker Hub
    TAG="$HUBACCOUNT/$IMG-$USERNAME"
    printf "\nPushing image $IMG as $TAG\n\n"
    docker tag $IMG $TAG
    docker push $TAG

  done < "$SCRIPT_DIR/$LIST"

  ;;

"deploy"|"destroy")

  if [ ! -d "$CRED_DIR" ]; then
    echo "Please log in first."
    exit 2
  fi

  # Load stored credentials & settings into environment variables
  ACCOUNT=`cat $CRED_DIR/account`
  CRED=(${ACCOUNT//:/ })
  export USERNAME=${CRED[0]}
  export PASSWORD=${CRED[1]}
  HUB=`cat $CRED_DIR/$USERNAME.hub`
  HUBCRED=(${HUB//:/ })
  export HUBACCOUNT=${HUBCRED[0]}

  # Transform the template by substituting the environment variables
  envsubst < $SCRIPT_DIR/$CONFIG.tmpl > $SCRIPT_DIR/$CONFIG.yaml

  # Deploy/delete this config to/from the Kubernetes cluster
  if [ $1 = "deploy" ]; then
    kubectl apply -f $SCRIPT_DIR/$CONFIG.yaml

    # Print url
    URL=`cat $SCRIPT_DIR/$CONFIG.yaml | grep 'host' | sed 's/- host://' | sed 's/ //g'`
    printf "\nOnce DNS propagation has completed, your service should become available on: \n  https://$URL\n\n"

  else
    kubectl delete -f $SCRIPT_DIR/$CONFIG.yaml
  fi
  
  # Clean up
  rm $SCRIPT_DIR/$CONFIG.yaml

  ;;

"dashboard")

  if [ ! -d "$CRED_DIR" ]; then
    echo "Please log in first."
    exit 2
  fi

  # Load stored username
  ACCOUNT=`cat $CRED_DIR/account`
  CRED=(${ACCOUNT//:/ })
  USERNAME=${CRED[0]}

  # Show token and open browser
  URL="https://dashboard.$CLUSTER#!/overview?namespace=$USERNAME"
  printf "\nUse the following token to sign in on the dashboard:\n\n"
  cat $CRED_DIR/$USERNAME.token
  printf "\nAnd select the namespace \"$USERNAME\" on the left.\n"
  printf "\nPress [enter] to open $URL in your default browser"
  read
  xdg-open $URL > /dev/null 2>&1

  ;;

*)
  printUsage
  ;;

esac