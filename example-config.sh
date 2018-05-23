# Example configuration. To create a config, rename this file to `config.sh`
# then change the values as you whish.
PROJECT="my-gce-project"
ZONE="us-east1-b"
CLUSTER_NAME="My Benchmark Cluster"
NODES="my-benchmark-node1 my-benchmark-node2 my-benchmark-node3"
SEED_NODES="my-benchmark-node1"
MONITORING_NODE="my-monitoring-node"
NIC="eth0"
DISKS="/dev/nvme0n1,/dev/nvme0n2"

# Only in --dev-mode
SCYLLA_REMOTE_NAME=my-scylla-remote
SCYLLA_REMOTE_URL=https://my-remote-url/repo.git
SEASTAR_REMOTE_NAME=my-seastar-remote
SEASTAR_REMOTE_URL=https://my-remote-url/repo.git
SCYLLA_BRANCH=my-scylla-branch
SEASTAR_BRANCH=my-seastar-branch
