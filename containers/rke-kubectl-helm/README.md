# rke-kubectl-helm

This conrtainer contains all the tools needed to setup a Rancher cluster using RKE.  


### SSH
1. In order to use this you will need to copy your **~/.ssh** folder to a **ssh** folder in the same directory as this Dockerfile. This will then use your ssh keys when communicating with your nodes. If you are using other keys, you can copy those keys into that **ssh** folder.  
2. You can also uncomment the **RUN ssh-keygen..** command in the Dockerfile to generate new keys. However, you will then need to add that key to the node, so RKE can access it.

### Setup 
```
# Build image
docker build -t dev-container .  

# Create volume. The volume mount is used to save the rke state and kubeconfig file.
docker volume create data

# Run container   
docker run -dit --name dev --mount source=data,target=/data dev-container /bin/bash

# Attach to the container to run commands from there
docker exec -it dev bash
```
