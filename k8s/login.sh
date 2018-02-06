#!/bin/bash
set -e

# 1. Ask for username/password

printf "Username: "
read USERNAME
printf "Password: "
read -s PASSWORD
printf "\n"

# 2. Store credentials

rm -rf credentials || true
mkdir credentials
echo $USERNAME > ./credentials/username
echo $PASSWORD > ./credentials/password

# 3. Get certificate and token from bastion

sshpass -p $PASSWORD scp $USERNAME@bastion.k8s.me:$USERNAME.* ./credentials/

# 4. Configure kubectl

kubectl config set-cluster k8s.me-$USERNAME --embed-certs=true --server=https://api.k8s.me/ --certificate-authority=./credentials/$USERNAME.crt
kubectl config set-credentials $USERNAME --token=`cat ./credentials/$USERNAME.token`
kubectl config set-context $USERNAME --cluster=k8s.me-$USERNAME --user=$USERNAME --namespace=$USERNAME
kubectl config use-context $USERNAME