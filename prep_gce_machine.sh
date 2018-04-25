#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage: $0 {node}"
    exit 1
fi

source ./config.sh

HOSTNAME=$1
SCYLLA_YAML=/etc/scylla/scylla.yaml

DEV_MODE=0

shift 1
while [ $# -gt 0 ]
do
    case $1 in
        "--dev-mode")
            DEV_MODE=1
            ;;
        *)
            echo "Unrecognized command line option: $1"
            exit 1
    esac
    shift 1
done

sudo yum install epel-release -y
sudo curl -o /etc/yum.repos.d/scylla.repo -L http://downloads.scylladb.com.s3.amazonaws.com/rpm/centos/scylla-nightly.repo

if [ $DEV_MODE -eq 1 ]
then
    sudo yum install git -y
    git clone https://github.com/scylladb/scylla.git && cd scylla && git submodule update --init --recursive
fi

sudo yum install tmux scylla-gdb scylla -y

sudo sed -i "s/#cluster_name: '.*Cluster'/cluster_name: '${CLUSTER_NAME}'/" ${SCYLLA_YAML}
sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"${SEED_NODES}\"/" ${SCYLLA_YAML}
sudo sed -i "s/listen_address: localhost/listen_address: ${HOSTNAME}/" ${SCYLLA_YAML}
sudo sed -i "s/rpc_address: localhost/rpc_address: ${HOSTNAME}/" ${SCYLLA_YAML}

sudo scylla_setup --disks ${DISKS}  --nic ${NIC} --setup-nic --no-enable-service --no-selinux-setup --no-bootparam-setup --no-cpuscaling-setup --no-fstrim-setup

if [ $DEV_MODE -eq 1 ]
then
    cd /usr/lib/systemd/system
    sudo sed -i "s#/usr/bin/scylla#/tmp/scylla#" scylla-server.service
fi
