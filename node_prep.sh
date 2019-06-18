#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage: $0 {node}"
    exit 1
fi

source ./config.sh

HOSTNAME=$1
SCYLLA_YAML=/etc/scylla/scylla.yaml

sudo yum install epel-release -y
sudo curl -o /etc/yum.repos.d/scylla.repo -L http://downloads.scylladb.com.s3.amazonaws.com/rpm/unstable/centos/master/latest/scylla.repo

sudo yum install tmux scylla-gdb scylla-tools scylla-jmx scylla -y

if [ ! -e scylla-relocatable-package ]
then
    mkdir scylla-relocatable-package
    mv ./scylla-relocatable-package.tar.gz scylla-relocatable-package
    cd scylla-relocatable-package
    tar -xf ./scylla-relocatable-package.tar.gz
else
    cd scylla-relocatable-package
fi

sudo ./install.sh

sudo sed -i "s/#cluster_name: '.*Cluster'/cluster_name: '${CLUSTER_NAME}'/" ${SCYLLA_YAML}
sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"${SEED_NODES}\"/" ${SCYLLA_YAML}
sudo sed -i "s/listen_address: localhost/listen_address: ${HOSTNAME}/" ${SCYLLA_YAML}
sudo sed -i "s/rpc_address: localhost/rpc_address: ${HOSTNAME}/" ${SCYLLA_YAML}

sudo scylla_setup --disks ${DISKS}  --nic ${NIC} --setup-nic --no-enable-service --no-selinux-setup --no-bootparam-setup --no-cpuscaling-setup --no-fstrim-setup

cd /var/lib/scylla && sudo mkdir hints && sudo chown scylla:scylla ./hints

echo "Done"
