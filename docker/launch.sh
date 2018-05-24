#!/bin/bash 
xhost +local:root

nvidia-docker run -it --rm \
--env="DISPLAY"  \
--env="QT_X11_NO_MITSHM=1"  \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--workdir="/home/$USER" \
--volume="$HOME/host_docker:/home/user/host_docker" \
--mount source=learn-ai,target="/home/$USER/dev" \
-e LOCAL_USER_ID=`id -u $USER` \
-e LOCAL_GROUP_ID=`id -g $USER` \
-e LOCAL_GROUP_NAME=`id -gn $USER` \
iandin/learn-ai:latest

xhost -local:root
