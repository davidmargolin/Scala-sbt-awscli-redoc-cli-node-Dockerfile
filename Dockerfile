#
# Scala, sbt, node, redoc, awscli, python Dockerfile
#
# https://github.com/davidmargolin/scala-sbt
#

# Pull base image
FROM openjdk:8u181

# Env variables
ENV SCALA_VERSION 2.12.6
ENV SBT_VERSION 1.2.3

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

# Install Node
RUN \ 
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get update && \
  apt-get install nodejs -y && \
  apt-get install npm -y && \
  apt-get install build-essential -y

# Install Redoc
RUN npm install -g redoc-cli

# Install Python and AWS
RUN \
  wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py --user && \
  ~/.local/bin/pip install --upgrade --user awscli && \
  echo "export PATH=~/.local/bin:$PATH" >> /root/.bashrc

# Define working directory
WORKDIR /root
