# Cluster setup

For those curious about how the Kubernetes cluster used in the workshop was set up on Microsoft Azure.

## Azure subscription

Step one: create an Azure subscription.

## DNS

 * Purchased the domain tasklist.nl from Versio
 * Set up a new DNS Zone on the Azure portal for this domain
 * Configured the Azure provided name servers on Version

Check:
```bash
nslookup -type=SOA tasklist.nl
```

## Kubernetes cluster creation and configuration

_Have a look at the following files: cluster.sh, rbac.yaml, cert.yaml._

### Sign in
```bash
./cluster.sh login
```

### Create AKS cluster
```bash
./cluster.sh create
```

### Deploy ingress and cert-manager
```bash
./cluster.sh configure
```

## Bastion creation and configuration

### VM creation

Created a big Ubuntu 18.04 VM using the Azure portal, with a public IP and SSH (port 22) opened to the internet.
SSH'ed into this machine for the following steps.

### Install tools

Install Docker, compose, kubectl, helm, Azure CLI, etc.
_Have a look at the following files: install.sh._

```bash
./install.sh
```

### Set up user accounts on bastion and namespaces on the cluster

_Have a look at the following files: accounts.sh, group.yaml.tmpl._

```bash
./accounts.sh
```

## Kubernetes dashboard

Opening the dashboard to the internet, (inadequately) protected with basic auth.
_Have a look at the following files: dashboard.sh, dash.yaml._

```bash
./dashboard.sh
```