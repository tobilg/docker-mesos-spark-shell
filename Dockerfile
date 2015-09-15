FROM ubuntu:14.04.3
MAINTAINER tobilg <fb.tools.github@gmail.com>

RUN apt-get update && apt-get install  -yq --no-install-recommends --force-yes \
    openjdk-7-jre-headless \
    wget \
    libsasl2-dev \
    libapr1-dev \
    libsvn-dev \
    libcurl4-nss-dev

# Mesos ENV vars
ENV MESOS_BUILD_VERSION 0.23.0

# Mesos install
RUN wget http://downloads.mesosphere.io/master/ubuntu/14.04/mesos_$MESOS_BUILD_VERSION-1.0.ubuntu1404_amd64.deb && \
    dpkg -i mesos_$MESOS_BUILD_VERSION-1.0.ubuntu1404_amd64.deb && \
    rm mesos_$MESOS_BUILD_VERSION-1.0.ubuntu1404_amd64.deb

# Spark ENV vars
ENV SPARK_VERSION 1.4.1
ENV SPARK_HOME /usr/local/spark
ENV SPARK_VERSION_STRING spark-$SPARK_VERSION-bin-hadoop2.6
ENV SPARK_DOWNLOAD_URL http://d3kbcqa49mib13.cloudfront.net/$SPARK_VERSION_STRING.tgz

# Install Spark
RUN wget $SPARK_DOWNLOAD_URL && \
    mkdir -p $SPARK_HOME && \
    tar xvf $SPARK_VERSION_STRING.tgz -C /tmp && \
    cp -rf /tmp/$SPARK_VERSION_STRING/* $SPARK_HOME/ && \
    rm -rf -- /tmp/$SPARK_VERSION_STRING && \
    rm spark-$SPARK_VERSION-bin-hadoop2.6.tgz

ENV PATH=$SPARK_HOME/bin:$PATH

ADD ./bootstrap.sh /usr/local/bin/
ADD ./spark-defaults.conf $SPARK_HOME/conf/

RUN sed -i 's|%SEU%|'$SPARK_EXECUTOR_URI'|g' $SPARK_HOME/conf/spark-defaults.conf

ENV MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos-$MESOS_BUILD_VERSION.so

CMD "/usr/local/bin/bootstrap.sh"

EXPOSE 4040 5000 5001 5002 5003 5004 5005