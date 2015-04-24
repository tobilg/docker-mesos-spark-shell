#!/bin/bash

export LIBPROCESS_IP=${SPARK_LOCAL_IP}

mesos_url="mesos://${MESOS_MASTER}:5050"

exec $SPARK_HOME/bin/spark-shell --master ${mesos_url} 