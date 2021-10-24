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




**Task 4)** Deploy the application into the K8S cluster

**4.1.** Create Deployment .yaml file with containerized application

