FROM jenkins/jenkins:lts

USER root
RUN apt update -y && \
    apt install -y python3-pip apt-transport-https ca-certificates curl gnupg2 software-properties-common

# For installing awscli
RUN pip3 install awscli yamlpath --upgrade 

# Installing docker client
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"

RUN apt update -y && \
    apt install -y docker-ce

# Setup Docker client to connect to Docker daemon running on host
# This docker daemon is from docker-in-docker-with-rootless image
ENV DOCKER_HOST=unix:///run/user/1000/docker.sock

RUN usermod -aG docker jenkins
RUN apt autoremove -y && \
    apt autoclean -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

USER jenkins