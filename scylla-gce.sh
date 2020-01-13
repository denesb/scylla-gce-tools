#!/bin/bash

source ./config.sh

build_reloc_command() {
    pushd ${SCYLLA_REPO}
    ./install-dependencies.sh
    ./reloc/build_reloc.sh
    ./reloc/build_rpm.sh
    ./reloc/python3/build_reloc.sh
    ./reloc/python3/build_rpm.sh
    popd

    pushd ${SCYLLA_TOOLS_JAVA_REPO}
    ./install-dependencies.sh
    ./reloc/build_reloc.sh
    ./reloc/build_rpm.sh
    popd

    pushd ${SCYLLA_JMX_REPO}
    ./install-dependencies.sh
    ./reloc/build_reloc.sh
    ./reloc/build_rpm.sh
    popd
}

create_command() {
    for node in $NODES
    do
        echo "Creating node ${node}..."
        gcloud beta compute --project "${PROJECT}" instances create "${node}" \
            --zone "${ZONE}" \
            --machine-type "${MACHINE_TYPE}" \
            --network "default" \
            --maintenance-policy "MIGRATE" \
            --service-account "skilled-adapter-452@appspot.gserviceaccount.com" \
            --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
            --min-cpu-platform "Automatic" \
            --local-ssd interface="NVME" \
            --local-ssd interface="NVME" \
            --image "centos-7-v20190905" \
            --image-project "centos-cloud" \
            --boot-disk-size "200" \
            --boot-disk-type "pd-standard" \
            --boot-disk-device-name "${node}"
    done
}

prepare_machine() {
    local node=$1
    shift 1

    echo $node

    (
cat <<END
#/bin/bash

sudo yum install -y tmux
sudo yum install -y ./rpms/*.rpm

sudo sed -i "s/#cluster_name: '.*Cluster'/cluster_name: '${CLUSTER_NAME}'/" /etc/scylla/scylla.yaml
sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"${SEED_NODES}\"/" /etc/scylla/scylla.yaml
sudo sed -i "s/listen_address: localhost/listen_address: ${node}/" /etc/scylla/scylla.yaml
sudo sed -i "s/rpc_address: localhost/rpc_address: ${node}/" /etc/scylla/scylla.yaml

sudo scylla_setup --disks ${DISKS}  --nic ${NIC} --setup-nic --no-enable-service --no-selinux-setup --no-bootparam-setup --no-cpuscaling-setup --no-fstrim-setup

cd /var/lib/scylla && sudo mkdir hints && sudo chown scylla:scylla ./hints

echo "Done"
END
    ) > prepare-${node}.sh

    gcloud compute scp --zone=${ZONE} prepare-${node}.sh ${node}:~/prepare.sh

    gcloud compute ssh --zone=${ZONE} ${node} --command="mkdir rpms"

    gcloud compute scp --zone=${ZONE} ${SCYLLA_REPO}/build/redhat/RPMS/x86_64/*.rpm ${node}:~/rpms
    gcloud compute scp --zone=${ZONE} ${SCYLLA_TOOLS_JAVA_REPO}/build/redhat/RPMS/noarch/*.rpm ${node}:~/rpms
    gcloud compute scp --zone=${ZONE} ${SCYLLA_JMX_REPO}/build/redhat/RPMS/noarch/*.rpm ${node}:~/rpms

    if [ -e ~/.tmux.conf ]
    then
        gcloud compute scp --zone=${ZONE} ~/.tmux.conf ${node}:~/
        echo asd
    fi

    gcloud compute ssh --zone=${ZONE} ${node} --command="chmod u+x ./prepare.sh && ./prepare.sh ${node}"

    rm -f prepare-${node}.sh
}

prepare_command() {
    for node in $NODES
    do
        prepare_machine $node &> ${node}.log &
    done

    wait
}

foreach_command() {
    for node in $NODES
    do
        gcloud compute ssh --zone=${ZONE} ${node} --command="${@}" &> ${node}.log &
    done
}

usage() {
    echo "Usage: $0 {command}"
    echo "Commands:"
    echo "    build_reloc - build relocatable packages in all repositories (scylla.git, scylla-tools-java.git, scylla-jmx.git)"
    echo "    create - create the GCE machines"
    echo "    prepare - prepare the GCE machines, install and configure scylla"
    echo "    foreach - execute a command on each machine"
}

if [ $# -lt 1 ]
then
    echo "Missing mandatory command argument."
    usage
    exit 1
fi

case $1 in
    build_reloc)
        cmd=build_reloc_command
        ;;
    create)
        cmd=create_command
        ;;
    prepare)
        cmd=prepare_command
        ;;
    foreach)
        cmd=foreach_command
        ;;
    --help)
        usage
        exit 0
        ;;
    -h)
        usage
        exit 0
        ;;
    *)
        echo "Invalid command '${1}', valid commands are: build_reloc, create, prepare and foreach"
        usage
        exit 1
        ;;
esac

shift 1

${cmd} $@
