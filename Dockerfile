FROM ubuntu:14.04.2
MAINTAINER tobilg <fb.tools.github@gmail.com>

RUN apt-get update && apt-get install  -yq --no-install-recommends --force-yes \
    openjdk-7-jre-headless \
    wget \
    libsasl2-dev

ENV SPARK_VERSION=spark-1.3.1-bin-hadoop2.6
ENV SPARK_FILE=$SPARK_VERSION.tgz
ENV SPARK_DOWNLOAD_URL=http://d3kbcqa49mib13.cloudfront.net/$SPARK_FILE

RUN wget $SPARK_DOWNLOAD_URL
RUN wget https://www.dropbox.com/s/a38g10ykjh5v2p0/libmesos-0.20.1.so?dl=0

RUN mkdir /usr/local/spark

RUN tar xvf $SPARK_FILE -C /usr/local/spark

ENV SPARK_HOME=/usr/local/spark/$SPARK_VERSION
ENV PATH=$SPARK_HOME/bin:$PATH

ADD ./bootstrap.sh /usr/local/bin/
ADD ./spark-defaults.conf $SPARK_HOME/conf/

RUN sed -i 's|%SEU%|'$SPARK_EXECUTOR_URI'|g' $SPARK_HOME/conf/spark-defaults.conf

RUN mv ./libmesos-0.20.1.so?dl=0 /usr/local/lib/libmesos-0.20.1.so
ENV MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos-0.20.1.so

CMD "/usr/local/bin/bootstrap.sh"

EXPOSE 4040 5000 5001 5002 5003 5004 5005