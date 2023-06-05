FROM jenkins/jenkins:2.356-jdk8
WORKDIR /var/jenkins_home

# install docker and docker-compose
USER root
RUN curl -fsSL https://get.docker.com | sh
RUN curl -fsSL https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# setup docker group
ARG HOST_DOCKER_GID
RUN usermod -aG docker jenkins
RUN groupmod -g $HOST_DOCKER_GID docker

USER jenkins
