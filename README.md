# k8s

## Set up Minikube on Ubuntu:
    https://phoenixnap.com/kb/install-minikube-on-ubuntu

## Set up Minikube on MacOS:
    https://matthewpalmer.net/kubernetes-app-developer/articles/guide-install-kubernetes-mac.html

## Start minikube:
    minikube start

## SSH to minikube machone:
    minikube ssh

## Build Docker image:
    docker build -t <username>/<image-name>:<tag> .

## Push Docker image to Docker Hub:
    docker login
    docker push <username>/<image-name>:<tag>

## Get Nodes list:
    kubectl get nodes
    kubectl describe nodes <node-name>

## Get Pods list:
    kubectl get pods
    kubectl describe pods <pod-name>

## Using Labels/Selector to list Pods:
    kubectl get pods --show-labels
    kubectl get pods -l <name>=<value>
    kubectl get pods --selector <name>=<value>
    kubectl get pods --selector "<name> in (<value1>,<value2>)"
    kubectl get pods --selector "<name> notin (<value1>,<value2>)"

## Get Services list:
    kubectl get service
    kubectl get svc
    kubectl describe service <service-name>

## Get Deployments list:
    kubectl get deployment
    kubectl get deploy
    kubectl describe deployment <deployment-name>

## Create Pod/Service/Deployment/PVC using manifest file:
    kubectl create -f <filename.yml>

## Delete Pod/Service/Deployment/PVC from manifest file:
    kubectl delete -f <filename.yml>

## Delete all resources:
    kubectl delete all --all

## Expose Deployment to specific port:
    kubectl expose deployment <deployment-name> --port 80 --type=NodePort
    kubectl expose deployment <deployment-name> --port 80 --type=ClusterIP
    kubectl expose deployment <deployment-name> --port 80 --type=LoadBalancer

## Perform Roll Update in Deployment:
    kubectl set image deployment <deployment-name> <container-name>=<image-name>:<tag>
    kubectl set image deployment <deployment-name> <container-name>=<image-name>:<tag> --record

## Minikube url:
    minikube ip
    minikube service <service-name>
    minikube service <service-name> --url
