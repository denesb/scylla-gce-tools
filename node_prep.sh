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
sudo curl -o /etc/yum.repos.d/scylla.repo -L http://downloads.scylladb.com.s3.amazonaws.com/rpm/centos/scylla-nightly.repo

if [ $DEV_MODE -eq 1 ]
then
    sudo yum install git -y
    git clone https://github.com/scylladb/scylla.git && cd scylla && git submodule update --init --recursive

    cd scylla

    if [ "${SCYLLA_REMOTE_NAME}" != "" ] && [ "${SCYLLA_REMOTE_URL}" != "" ]
    then

        git remote add ${SCYLLA_REMOTE_NAME} ${SCYLLA_REMOTE_URL}
        git fetch ${SCYLLA_REMOTE_NAME}
    fi

    if [ "${SCYLLA_BRANCH}" != "" ]
    then
        git checkout ${SCYLLA_BRANCH}
    fi

    cd seastar

    if [ "${SEASTAR_REMOTE_NAME}" != "" ] && [ "${SEASTAR_REMOTE_URL}" != "" ]
    then

        git remote add ${SEASTAR_REMOTE_NAME} ${SEASTAR_REMOTE_URL}
        git fetch ${SEASTAR_REMOTE_NAME}
    fi

    if [ "${SEASTAR_BRANCH}" != "" ]
    then
        git checkout ${SEASTAR_BRANCH}
    fi

    cd ~
fi

sudo yum install tmux scylla-gdb scylla -y

sudo sed -i "s/#cluster_name: '.*Cluster'/cluster_name: '${CLUSTER_NAME}'/" ${SCYLLA_YAML}
sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"${SEED_NODES}\"/" ${SCYLLA_YAML}
sudo sed -i "s/listen_address: localhost/listen_address: ${HOSTNAME}/" ${SCYLLA_YAML}
sudo sed -i "s/rpc_address: localhost/rpc_address: ${HOSTNAME}/" ${SCYLLA_YAML}

sudo scylla_setup --disks ${DISKS}  --nic ${NIC} --setup-nic --no-enable-service --no-selinux-setup --no-bootparam-setup --no-cpuscaling-setup --no-fstrim-setup

cd /var/lib/scylla && sudo mkdir hints && sudo chown scylla:scylla ./hints

if [ $DEV_MODE -eq 1 ]
then
    cd /usr/lib/systemd/system
    sudo sed -i "s#/usr/bin/scylla#/tmp/scylla#" scylla-server.service
fi

echo "Done"
