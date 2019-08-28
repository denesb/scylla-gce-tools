#!/bin/bash

source ./config.sh

prep_machine() {
    local node=$1
    shift 1

    echo $node

    gcloud compute scp --zone=${ZONE} ./node_prep.sh ${node}:~/prep.sh
    gcloud compute scp --zone=${ZONE} ./config.sh ${node}:~/config.sh

    gcloud compute ssh --zone=${ZONE} ${node} --command="mkdir rpms"

    gcloud compute scp --zone=${ZONE} ${SCYLLA_REPO}/build/redhat/RPMS/x86_64/*.rpm ${node}:~/rpms
    gcloud compute scp --zone=${ZONE} ${SCYLLA_TOOLS_JAVA_REPO}/build/redhat/RPMS/noarch/*.rpm ${node}:~/rpms
    gcloud compute scp --zone=${ZONE} ${SCYLLA_JMX_REPO}/build/redhat/RPMS/noarch/*.rpm ${node}:~/rpms

    if [ -e ~/.tmux.conf ]
    then
        gcloud compute scp --zone=${ZONE} ~/.tmux.conf ${node}:~/
    fi

    gcloud compute ssh --zone=${ZONE} ${node} --command="chmod u+x ./prep.sh && ./prep.sh ${node}"
}

for node in $NODES
do
    prep_machine $node &> ${node}.log &
done

wait
