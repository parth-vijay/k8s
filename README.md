# Kubernetes Set up in AWS EKS

## Install *kubectl* (official Kubernetes client):
**Ubuntu**:-
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    kubectl version --client
    kubectl cluster-info

**Red Hat-based distributions**:-
    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF

    sudo yum install -y kubectl
    kubectl version --client
    kubectl cluster-info

**MacOS**:-
    ```brew install kubectl
    kubectl version --client
    kubectl cluster-info```

## Install *awscli*:
**Ubuntu**:-
    sudo apt-get install awscli
    aws --version

**MacOS**:-
    brew install awscli
    aws --version

## Install Helm:
**Ubuntu**:
    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    sudo apt-get install apt-transport-https --yes
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm

**MacOS**:
    brew install helm

## Create a cluster in AWS EKS:

**Prerequisites**:-

An existing VPC and a dedicated security group that meet the requirements for an Amazon EKS cluster. For more information, see Cluster VPC considerations and Amazon EKS security group considerations. If you don't have a VPC, you can follow to create one.

An existing Amazon EKS cluster IAM role. If you don't have the role, you can follow Amazon EKS IAM roles to create one.
To create your cluster with the console:-
1. Open the Amazon EKS console at https://console.aws.amazon.com/eks/home#/clusters.
2. Choose **Create cluster**.
3. On the **Configure cluster** page, fill in the following fields:
    * **Name** – A unique name for your cluster.
    * **Kubernetes version** – The version of Kubernetes to use for your cluster.
    * **Cluster Service Role** – Choose the Amazon EKS cluster role to allow the Kubernetes control plane to manage AWS resources on your behalf.
4. Select **Next**.
5. On the **Specify networking** page, select values for the following fields:
    * **VPC** – Select an existing VPC to use for your cluster. If none are listed, then you need to create one first.
    * **Subnets** – By default, the available subnets in the VPC specified in the previous field are preselected. Unselect any subnet that you don't want to host cluster resources, such as worker nodes or load balancers. The subnets must meet the requirements for an Amazon EKS cluster.
6. Select Kubernetes version.
7. Select **Next**.
8. On the **Configure logging** page, you can optionally choose which log types that you want to enable. By default, each log type is **Disabled**.
9. Select **Next**.
10. On the **Review and create** page, review the information that you entered or selected on the previous pages. Select **Edit** if you need to make changes to any of your selections. Once you're satisfied with your settings, select **Create**. The **Status** field shows **CREATING** until the cluster provisioning process completes.

    ```Note:
    You might receive an error that one of the Availability Zones in your request doesn't have sufficient capacity to create an Amazon EKS cluster. If this happens, the error output contains the Availability Zones that can support a new cluster. Retry creating your cluster with at least two subnets that are located in the supported Availability Zones for your account. For more information, see Insufficient capacity.```

## Creating a managed node group:

1. Wait for your cluster status to show as ACTIVE. You can't create a managed node group for a cluster that isn't already ACTIVE.
2. Open the Amazon EKS console at https://console.aws.amazon.com/eks/home#/clusters.
3. Choose the name of the cluster that you want to create your managed node group in.
4. Select the **Configuration** tab.
5. On the **Configuration** tab, select the **Compute** tab, and then choose **Add Node Group**.
6. On the **Configure node group** page, fill out the parameters accordingly, and then choose **Next**.
    * **Name** – Enter a unique name for your managed node group.
    * **Node IAM role name** – Choose the node instance role to use with your node group.
7. On the **Set compute and scaling configuration** page, fill out the parameters accordingly, and then choose **Next**.
    * **AMI type** – Choose **Amazon Linux 2 (AL2_x86_64)** for Linux non-GPU instances, **Amazon Linux 2 GPU Enabled (AL2_x86_64_GPU)** for Linux GPU instances, **Amazon Linux 2 (AL2_ARM_64)** for Linux Arm instances.
    * **Capacity type** – Select a capacity type.
    * **Instance type** – By default, one or more instance type is specified.
    * **Disk size** – Enter the disk size (in GiB) to use for your node's root volume.
    * **Minimum size** – Specify the minimum number of nodes that the managed node group can scale in to.
    * **Maximum size** – Specify the maximum number of nodes that the managed node group can scale out to.
    * **Desired size** – Specify the current number of nodes that the managed node group should maintain at launch.
    * For **Maximum unavailable**, select one of the following options and specify a **Value**:
        + **Number** – Select and specify the number of nodes in your node group that can be updated in parallel. These nodes will be unavailable during update.
        + **Percentage** – Select and specify the percentage of nodes in your node group that can be updated in parallel. These nodes will be unavailable during update. This is useful if you have a large number of nodes in your node group.
8. On the **Specify networking** page, fill out the parameters accordingly, and then choose **Next**.
    * **Subnets** – Choose the subnets to launch your managed nodes into.
    * **Configure SSH access to nodes** (Optional). Enabling SSH allows you to connect to your instances and gather diagnostic information if there are issues. Complete the following steps to enable remote access. We highly recommend enabling remote access when you create your node group. You can't enable remote access after the node group is created.
    * For **SSH key pair** (Optional), choose an Amazon EC2 SSH key to use. For more information, see Amazon EC2 key pairs in the Amazon EC2 User Guide for Linux Instances. If you chose to use a launch template, then you can't select one.
9. On the **Review and create** page, review your managed node group configuration and choose **Create**.

## Configuring the AWS CLI:
    aws configure set aws_access_key_id <AWS_ACCESS_KEY_ID>
    aws configure set aws_secret_access_key <AWS_SECRET_ACCESS_KEY>
    aws configure set default.region <AWS_DEFAULT_REGION>

## AWS EKS commands:
    aws eks list-clusters
    aws eks list-nodegroups --cluster-name <CLUSTER_NAME>

## Create a *kubeconfig* for AWS EKS:
    aws eks --region <REGION_NAME> update-kubeconfig --name <CLUSTER_NAME> --kubeconfig <CONFIG_FILE_NAME>

## Create Docker secrets in EKS cluster:
    kubectl create secret docker-registry docker-reg --docker-server=https://index.docker.io/v1/  --docker-username=<USERNAME>  --docker-password=<PASSWORD> --kubeconfig <CONFIG_FILE_NAME>

## Create cluster *Environments* secrets for the staging:
    bash stagsecret.sh

## Cretae cluster *Environments* secrets for production:
    bash prodsecret.sh

## Create TSL Certificate secret in cluster:
    kubectl create secret tls letsencrypt_prod --cert=<CERTIFICATE_FILE> --key=<PRIVATE_KEY>

## Run Helm charts for *cro-server-chart*:
    helm upgrade --install --kubeconfig=<CONFIG_FILE_NAME> --set env="production" --set image.tag=latest --set image.name=prod-cro-server --set autoscaling.enable=true --set ingress.issuer=letsencrypt-prod --set ingress.hostName=api.codecrow.io --set ingress.tls[0].hosts[0]=api.codecrow.io --set ingress.tls[0].secretName=letsencrypt-prod code-crow-server-prod cro-server-chart --kubeconfig <CONFIG_FILE_NAME>

## Run Helm charts for *cro-client-chart*:
    helm upgrade --install --kubeconfig=<CONFIG_FILE_NAME> --set env="production" --set image.tag=latest  --set image.name=prod-cro-client --set autoscaling.enable=true --set ingress.hostName=codecrow.io --set ingress.tls[0].hosts[0]=codecrow.io code-crow-client-prod cro-client-chart --kubeconfig <CONFIG_FILE_NAME>

## Get Pods status:
    kubectl get pods --kubeconfig <CONFIG_FILE_NAME>
    kubectl get pods -o wide --kubeconfig <CONFIG_FILE_NAME>

## Get Service status:
    kubectl get svc --all-namespaces --kubeconfig <CONFIG_FILE_NAME>

## Deploy Nginx Ingress Service on EKS cluster:
    helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace --kubeconfig <CONFIG_FILE_NAME>

## Get Ingress Manifest file from Helm Chart:
    helm template -s templates/ingress.yaml . --kubeconfig <CONFIG_FILE_NAME> >  ingress-manifest.yml

## Apply Ingress file to cluster:
    kubectl apply -f ingress-manifest.yml --kubeconfig <CONFIG_FILE_NAME>

## Get Ingress status:
    kubectl get ingress --all-namespaces --kubeconfig <CONFIG_FILE_NAME>

## Add AWS EKS Load Balancer to the AWS Global Accelerator:
1. Login to your **AWS ELB Console**
2. Select the **Load Balancer** that you want to enable acceleration for.
3. Scroll down and click on **Integrated Services** tab.
4. Select Create Accelerator and it prompts to you enter the **Global Accelerator** name in the box. Select the name as per the requirements given in the prompt.
5. Once the **Global Accelerator** is created, you should see the following information on your ELB console.

## Get the Global Accelerator IP:
1. Go to **Global Accelerator** dashboard in AWS Console.
2. Click the **Accelerator** and get the **Static IP address set**.
3. Creaet the DNS record for the IP to point the domain.

## Thanks, Happy Clustering!