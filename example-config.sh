# Example configuration. To create a config, rename this file to `config.sh`
# then change the values as you wish.
PROJECT="my-gce-project"
ZONE="us-east1-b"
MACHINE_TYPE=n1-standard-4
CLUSTER_NAME="My Benchmark Cluster"
NODES="my-benchmark-node1 my-benchmark-node2 my-benchmark-node3"
SEED_NODES="my-benchmark-node1"
NIC="eth0"
DISKS="/dev/nvme0n1,/dev/nvme0n2"

SCYLLA_REPO=/path/to/scylla
SCYLLA_TOOLS_JAVA_REPO=/path/to/scylla-tools-java
SCYLLA_JMX_REPO=/path/to/scylla-jmx
