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
   
2.2 Install git and clone repository
   
    sudo apt install git
    # verify versions of installed tools
    git --version
    
   
   


**Task 3)** Setup K8S cluster using Minikube (1 master + 1 worker) 


**Task 4)** Deploy the application into the K8S cluster

**4.1.** Create Deployment .yaml file with containerized application

