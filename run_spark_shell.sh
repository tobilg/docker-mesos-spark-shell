docker run -i -t \
    --net=host \
    -e MESOS_MASTER=127.0.0.1 \
    -e SPARK_LOCAL_IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}') \
    -e SPARK_EXECUTOR_URI=%%PATH_TO_SPARK_BINARIES%% \
    -p 4040:4040 \
    -p 5000:5000 \
    -p 5001:5001 \
    -p 5002:5002 \
    -p 5003:5003 \
    -p 5004:5004 \
    -p 5005:5005 \
    --name spark-shell \
    tobilg/mesos-spark-shell:latest