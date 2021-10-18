FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install language-pack-ja sudo curl apt-transport-https awscli \
    ca-certificates \
    gnupg-agent \
    software-properties-common --yes
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
RUN apt update && apt-get install docker-ce docker-ce-cli containerd.io --yes

ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8

RUN useradd runner -m && echo runner:secret | chpasswd

USER runner
WORKDIR /home/runner

RUN mkdir actions-runner && cd actions-runner
RUN curl -o actions-runner-linux-x64-2.283.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.283.2/actions-runner-linux-x64-2.283.2.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.283.2.tar.gz

USER root

RUN ./bin/installdependencies.sh
RUN gpasswd -a runner sudo && gpasswd -a runner docker
