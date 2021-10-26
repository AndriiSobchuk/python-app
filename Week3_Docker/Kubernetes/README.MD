**Task 1.)** Fork repo https://github.com/ingvar-goryainov/python-app

I forked repo:

![fork](https://user-images.githubusercontent.com/86925275/138555475-6ce90d61-2c89-4725-81a0-bb962b808ccb.png)

**Task 2.)** Build docker image with Python application

2.1 Install docker 
       
    sudo apt update
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
    sudo apt update
    sudo apt-get install docker-ce 
    # verify versions of installed tools
    docker --version
    
    # add Docker user and group 
    sudo usermod -aG docker $USER && newgrp docker
    
    #add Docker to aoutostart
    sudo systemctl enable docker
    sudo systemctl start docker
   
2.2 Install git and clone repository
   
   
   
    sudo apt install git
    # verify versions of installed tools
    git --version
    
 2.3 Clone the repository 
 
    git clone https://github.com/AndriiSobchuk/python-app

2.4 Create Dockerfile

    FROM python:3.7-alpine3.14
    COPY ./application /home/python-user
    WORKDIR /home/python-user

    RUN adduser -s /bin/sh -h /home/python-user -D python-user && \
    pip3 install --no-cache-dir aiohttp multidict==4.5.2 yarl==1.3.0 && \
    python3 setup.py install

    USER python-user
    ENV PATH="/home/python-user/.local/bin:$PATH"
    EXPOSE 8080
    CMD ["python3", "-m", "demo"]
    
 2.5 Build image from Dockerfile
 
 ![docker-image](https://user-images.githubusercontent.com/86925275/138612770-9300121b-f265-4440-8bda-57722111d830.png)

 2.6 Run Docker container and verify connection
 
 ![docker-run](https://user-images.githubusercontent.com/86925275/138613356-5767bdf3-b5a6-4e44-ba46-ee344930c16a.png)
 
 ![docker-run-2](https://user-images.githubusercontent.com/86925275/138613419-e5ef3ec1-8e3d-4211-be39-7894070e2539.png)

 
  2.7 Push image to DockerHub
  
  I executed the following commands:
  
     docker ps  # to find out container id 
     docker commit efbb66d4eecc andriisobchuk/python-app # set the image name
     docker login # login to remote DockerHub
     docker push andriisobchuk/python-app #push image to DockerHub
  
  
 ![docker-push](https://user-images.githubusercontent.com/86925275/138614517-0c761c5d-187f-47d3-8ec8-dbdc45ed7b5b.png)

 ![docker-hub-2](https://user-images.githubusercontent.com/86925275/138614775-e78ff032-65f3-449a-84e7-b371600e7891.png)

 
   
   


**Task 3)** Setup K8S cluster using Minikube (1 master + 1 worker) 

3.1 Install kubectl 

      curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
      chmod +x ./kubectl
      sudo mv ./kubectl /usr/local/bin/kubectl
      kubectl version --client
![KUBECTL](https://user-images.githubusercontent.com/86925275/138558047-50f9a2ad-e06e-4098-a2ab-4558c4196cae.png)

3.2  Install minikube

      curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
      sudo mkdir -p /usr/local/bin/
      sudo install minikube /usr/local/bin/ 
      minikube start --nodes 2 -p worker
      
      #verify we added 2 nodes ( master and worker) 
      kubectl get nodes
      
![minikube-srv-nodes](https://user-images.githubusercontent.com/86925275/138562873-faef27fc-2ec4-4d79-b644-ee1c881bc1a2.png)


![minikube-status](https://user-images.githubusercontent.com/86925275/138967310-a52bead9-a0e2-445d-a4ba-5e5b98194803.png)


**Task 4)** Deploy the application into the K8S cluster

**4.1.** Create Deployment .yaml file with containerized application and deploy app

    kubectl create deployment python-app --dry-run=client --image=andriisobchuk/python-app -o yaml >> python-app.yaml 
 
 Verify .yaml file: 
 
 ![yaml-scr-base](https://user-images.githubusercontent.com/86925275/138967359-ea3bee2d-db83-4491-9821-161026b12a48.png)

 Deploy application:

    kubectl apply -f python-app.yaml 
    
    
 Verify pod and deployment:

    
   ![kube-deploy](https://user-images.githubusercontent.com/86925275/138639831-978af131-a038-431e-a91b-a92aa662d42b.png)

    
** Optional Task 1 ** The deployment requires 3 replicas, "RollingUpdate" strategy. Emulate the "RollingUpdate" strategy by updating docker image. Define the liveness and readiness probes to /health endpoint 8080 port, resources (request/limits)

I updated my python-app.yaml file:

![new_yaml](https://user-images.githubusercontent.com/86925275/138971815-61b31d8a-af74-4ad0-9757-421b595b5841.png)

And then run deloyment once again with: 

       kubectl apply -f python-app.yaml 
 
And verify pods and rolling update:





** Optional Task 2 ** Create a service object whitch exposes Pods with application outside the K8S cluster in order to access each of the replicas through the single  IP address/DNS name

         kubectl expose deployment python-app --port=8080 --type=NodePort --name=python-app

** Optional Task 3 ** Specify PodDistributionBudget whitch defines that only 1 replica can be down
   
For this purpose I create new .yaml file:  policy.yaml. Where I specified the PodDistributionBudget

![policy](https://user-images.githubusercontent.com/86925275/138972652-35d583ca-c574-4ff4-959a-a274c9ad92bc.png)

Then I executed the following commands to deployment and verify everithing works:

       kubectl apply -f policy.yaml
       kubectl get poddisruptionbudget.policy
       
![policy-2](https://user-images.githubusercontent.com/86925275/138972737-1dea6298-d720-4551-b511-720c15302613.png)



