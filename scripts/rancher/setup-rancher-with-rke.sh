#!/bin/sh

# Generate an SSH Keypair
ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -N ""
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Install RKE
sudo wget -O /usr/local/bin/rke \https://github.com/rancher/rke/releases/download/v1.0.2/rke_linux-amd64
sudo chmod +x /usr/local/bin/rke
rke -v

# Install kubectl 
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
kubectl version --client --short

# Install Helm
sudo wget -O helm.tar.gz https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz
sudo tar -zxf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo chmod +x /usr/local/bin/helm
sudo rm -rf linux-amd64
sudo rm -f helm.tar.gz
helm version --client

# Create a rancher-cluster.yml file. Enter IP address for the node. 
cat << EOF > rancher-cluster.yml
nodes:  
  - address: [PUBLIC IP]
#    internal_address: [PRIVATE IP]
    user: ubuntu
    role: [controlplane,etcd,worker]
addon_job_timeout: 120
EOF

# Provision Kubernetes cluster
rke up --config rancher-cluster.yml

# Setup config file
mkdir -p /root/.kube
ln -s /data/kube_config_rancher-cluster.yml /root/.kube/config

# Install cert-manager
kubectl create namespace cert-manager
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager --namespace cert-manager --version v0.12.0 jetstack/cert-manager
kubectl -n cert-manager rollout status deploy/cert-manager
kubectl -n cert-manager rollout status deploy/cert-manager-webhook

# Install Rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
kubectl create namespace cattle-system
# You have to add a hostname, that Rancher will use for all communication.
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=ADD-HOSTNAME --set replicas=1
# helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=ADD-HOSTNAME --set replicas=1 --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=ADD-EMAIL

# Install kubectx and kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Setup easy aliases
alias k=kubectl >> /root/.bashrc
alias kx=kubectx >> /root/.bashrc
alias ns=kubens >> /root/.bashrc
