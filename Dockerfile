FROM jenkinsci/slave:alpine
MAINTAINER xy1219.zhao <zhaoxingyuanyuan@gmail.com>
USER root
RUN apk add --no-cache curl tar bash
ENV DOCKER_VERSION=17.04.0-ce  DOCKER_COMPOSE_VERSION=1.21.2
#######
# Maven
#######
 
# Preparation
 
ENV MAVEN_VERSION 3.6.1
ENV MAVEN_HOME /etc/maven-${MAVEN_VERSION}
 
# Installation
 
RUN cd /tmp
RUN wget http://mirror.bit.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN mkdir maven-${MAVEN_VERSION}
RUN tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz --directory maven-${MAVEN_VERSION} --strip-components=1
RUN mv maven-${MAVEN_VERSION} ${MAVEN_HOME}
ENV PATH ${PATH}:${MAVEN_HOME}/bin

# Cleanup
 
RUN rm apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN unset MAVEN_VERSION

#######
# docker-ce
#######
#RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
		&& tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin \
		&& chmod -R +x /usr/local/bin/docker

#######
# docker-compose
#######

#RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

#######
# install kubectl
#######
COPY kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

## install jenkins-slave
COPY jenkins-slave /usr/local/bin/jenkins-slave
WORKDIR /home/jenkins
ENTRYPOINT ["jenkins-slave"]