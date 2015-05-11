# Mesos Spark Shell

A docker image for creating a Spark shell on a Mesos cluster. Currently, Mesos 0.22.1-rc6 is supported on `master`. The `libmesos.so` was compiled with the [tobilg/docker-mesos](https://github.com/tobilg/docker-mesos) image, extracted and uploaded to Dropbox for being used in the Dockerfile.

### Running

To see how to run the Docker image, have a look a the `run_spark_shell.sh` file. Basically, you just need to replace the `MESOS_MASTER_IP` with the actual IP the Mesos Master is living on, 
and the `SPARK_EXECUTOR_URI` variable needs to point to a "Spark package" where the Spark binaries are reachable for the Mesos Slaves' Executors to download, see [Spark docs](https://spark.apache.org/docs/latest/running-on-mesos.html#uploading-spark-package). 

Example:

```
docker run -i -t \
    --net=host \
    -e MESOS_MASTER=127.0.0.1:5050 \
    -e SPARK_LOCAL_IP=127.0.0.1 \
    -e SPARK_EXECUTOR_URI=http://d3kbcqa49mib13.cloudfront.net/spark-1.3.1-bin-hadoop2.6.tgz \
    -p 4040:4040 \
    -p 5000:5000 \
    -p 5001:5001 \
    -p 5002:5002 \
    -p 5003:5003 \
    -p 5004:5004 \
    -p 5005:5005 \
    --name spark-shell \
    tobilg/mesos-spark-shell
```

### Networking
Eventually, you'll also need to set the `SPARK_LOCAL_IP` variable to the public IP address of your Docker host if the Mesos cluster is run in non-local mode, as well as `--net=host`. 

To automatically determine the IP address, on RedHat/CentOS/Fedora-based hosts', the `SPARK_LOCAL_IP` line needs to replaced with

    -e SPARK_LOCAL_IP=$(/sbin/ifconfig eth0 | grep 'inet ' | awk '{print $2}') \

For Debian/Ubuntu-based hosts, use 

    -e SPARK_LOCAL_IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

Be sure to replace `eth0` with the actual interface your host is using for external access. 

### Ports
The ports 5000 - 5005 (see `spark-defaults.conf`) are opened to be reachable for the Mesos Master.
