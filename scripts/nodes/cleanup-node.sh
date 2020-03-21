#!/bin/sh

# Delete all containers and data 
docker rm -f $(docker ps -aq) 
docker volume prune -f
docker system prune -f 

# Delete all Rancher and RKE created files
rm -rf /etc/ceph \
       /etc/cni \
       /etc/kubernetes \
       /opt/cni \
       /opt/rke \
       /run/secrets/kubernetes.io \
       /run/calico \
       /run/flannel \
       /var/lib/calico \
       /var/lib/etcd \
       /var/lib/cni \
       /var/lib/kubelet \
       /var/lib/rancher/rke/log \
       /var/log/containers \
       /var/log/pods \
       /var/run/calico

# Delete interface created by flannel (if Flannel is used) 
ip link delete flannel.1


