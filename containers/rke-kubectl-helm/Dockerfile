FROM ubuntu:latest

ENV rke_version=v1.0.2
ENV helm_version=helm-v3.0.2-linux-amd64

COPY ssh/*  /root/.ssh/

RUN apt-get update && \
apt-get install git openssh-client openssh-server curl wget apt-utils gnupg2 vim -y 

#RUN ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -N "" && \
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN wget -O /usr/local/bin/rke https://github.com/rancher/rke/releases/download/${rke_version}/rke_linux-amd64 && \
chmod +x /usr/local/bin/rke && \
rke -v

RUN apt-get install -y apt-transport-https && \
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
apt-get update && \
apt-get install -y kubectl && \
kubectl version --client --short

RUN wget -O helm.tar.gz https://get.helm.sh/${helm_version}.tar.gz && \
tar -zxf helm.tar.gz && \
mv linux-amd64/helm /usr/local/bin/helm && \
chmod +x /usr/local/bin/helm && \
rm -rf linux-amd64 && \
rm -f helm.tar.gz && \
helm version --client

RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

RUN echo "alias k=kubectl" >> /root/.bashrc && \
echo "alias kx=kubectx" >> /root/.bashrc && \
echo "alias ns=kubens" >> /root/.bashrc

CMD ["sleep", "infinity"]
