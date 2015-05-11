# Mesos Spark Shell

A docker image for creating a Spark shell on a Mesos cluster. Currently, Mesos 0.20.1 is supported.

### Running

To see how to run the Docker image, have a look a the `run_spark_shell.sh` file. Basically, you just need to replace the `%%MESOS_MASTER_IP%%` with the actual IP the Mesos Master is living on, and the `%%PATH_TO_SPARK_BINARIES%%` with the actual URL where the Spark binaries are reachable for the Mesos Slaves' Executors to download.

Eventually, you'll also need to set the `SPARK_LOCAL_IP` variable to the public IP address of your Docker host if the Mesos cluster is run in non-local mode. 

The ports 5000 - 5005 (see `spark-defaults.conf`) are opened to be reachable for the Mesos Master.
