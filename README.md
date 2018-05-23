# Dockerizing your AI Development Enviroment

I always take a long time to setup my dev machines with all the tools, libs, etc. Since I usually work on multiple machines it is really painful to keep them sync and alike.

Although bash scripts are great to setup a dev environment they will not ensure a consistent global configuration of your machines since, probably, you are going to install a lot of stuff along the way in addition to your dev tools.

A solution I've came to find quite interesting is the use of docker to create isolated development environments that are self-contained and populated only by the right amount of software.

In the next few lines I'll explain step-by-step how you can deploy a container pre-populated with the following AI tools:

* R
* Keras (TBD)
* Tensorflow (TBD)
* OpenGym AI (TBD)


## Step 1: Install Docker

Install docker https://docs.docker.com/engine/installation/linux/ubuntu/

To run docker without super user:

```bash
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart
```

## Step 2: NVIDIA acceleration

Install nvidia-docker (to get HW acceleration https://github.com/NVIDIA/nvidia-docker/wiki

_Note: We'll use here the nvidia-docker 1.0 legacy version since the new nvidia-docker2 still lacks support to OpenGL_  

## Step 3: Building the 'learn-ai' Docker Image

If you want to skip the small talk and get straigh down to business just run on your terminal:

```bash
$ docker pull iandin/learn-ai:latest
```

Alternatively, we can build our docker image from the Dockerfile in the repo. To do this, after cloning the git repo:

```bash
$ cd docker
$ docker build -t learn-ai:latest .
```

## Step 4: Create an External Docker Volume

To avoid having to checkout each time the git repo code, we'll create a docker external volume and later will mount it while launching our container:

```bash
$ docker volume create learn-ai
```

## Step 5: Start the Container

The launch.sh bash script will call nvidia-docker with the appropriate parameters in order to start a docker container based on our image 'learn-ai':

```bash
# You migh need to call add execution permission to our launch file
$ chmod +x ./launch.sh
$ ./launch.sh
``` 

As mentioned in step 4, during launch time we mount the previously created docker volume named 'learn-ai' onto a folder named 'dev'. Now, after starting the container, once in bash, we'll clone the git repo:

```bash
$ cd /home/$USER/dev  # $USER is your user folder
$ git clone https://github.com/iandix/learn-ai.git
```

_Note: An important point to note is that our launch script is configured to remove the  container after leaving. This is required since nvidia-docker accepts configuration parameters only over the run command. So we can't use 'docker exec' later to get into our previously launched container and expect the GUI to work._

## Working with the AI tooling

```bash
$ rstudio  # To start working with R in RStudio
```