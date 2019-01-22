# phalcon-codeception-docker

Basic docker container with the latest phalcon and codeception to use cmd line

## Terminal approach 
Starts a container and mounts your working dir and enter a sh console

$ docker run -v ${PWD}:/project -it --entrypoint=sh --rm ruudboon/phalcon-codeception
