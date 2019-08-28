#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage: $0 {node}"
    exit 1
fi

source ./config.sh

HOSTNAME=$1
SCYLLA_YAML=/etc/scylla/scylla.yaml

sudo yum install -y tmux
sudo yum install -y ./rpms/*.rpm

sudo sed -i "s/#cluster_name: '.*Cluster'/cluster_name: '${CLUSTER_NAME}'/" ${SCYLLA_YAML}
sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"${SEED_NODES}\"/" ${SCYLLA_YAML}
sudo sed -i "s/listen_address: localhost/listen_address: ${HOSTNAME}/" ${SCYLLA_YAML}
sudo sed -i "s/rpc_address: localhost/rpc_address: ${HOSTNAME}/" ${SCYLLA_YAML}

sudo scylla_setup --disks ${DISKS}  --nic ${NIC} --setup-nic --no-enable-service --no-selinux-setup --no-bootparam-setup --no-cpuscaling-setup --no-fstrim-setup

cd /var/lib/scylla && sudo mkdir hints && sudo chown scylla:scylla ./hints

echo "Done"
