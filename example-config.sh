# Example configuration. To create a config, rename this file to `config.sh`
# then change the values as you whish.
PROJECT="my-gce-project"
ZONE="us-east1-b"
MACHINE_TYPE=n1-standard-4
CLUSTER_NAME="My Benchmark Cluster"
NODES="my-benchmark-node1 my-benchmark-node2 my-benchmark-node3"
SEED_NODES="my-benchmark-node1"
MONITORING_NODE="my-monitoring-node"
NIC="eth0"
DISKS="/dev/nvme0n1,/dev/nvme0n2"

# Whether rpms or the git repo should be set up on the nodes
# 0: use rpms
# 1: use git repo
DEV_MODE=0

# Only with DEV_MODE=1
SCYLLA_REMOTE_NAME=my-scylla-remote
SCYLLA_REMOTE_URL=https://my-remote-url/repo.git
SEASTAR_REMOTE_NAME=my-seastar-remote
SEASTAR_REMOTE_URL=https://my-remote-url/repo.git
SCYLLA_BRANCH=my-scylla-branch
SEASTAR_BRANCH=my-seastar-branch
