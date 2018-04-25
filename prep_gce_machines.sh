#!/bin/bash -x

source ./config.sh

prep_machine() {
    local node=$1
    shift 1

    echo $node

    gcloud compute scp --zone=${ZONE} ./prep_gce_machine.sh ${node}:~/prep.sh
    gcloud compute scp --zone=${ZONE} ./config.sh ${node}:~/config.sh

    for rpm in `ls *.rpm`
    do
        gcloud compute scp --zone=${ZONE} ${rpm} ${node}:~/
    done

    if [ -e ~/.tmux.conf ]
    then
        gcloud compute scp --zone=${ZONE} ~/.tmux.conf ${node}:~/
    fi

    gcloud compute ssh --zone=${ZONE} ${node} --command="./prep.sh ${node} ${@}"
}

for node in $NODES
do
    prep_machine $node $@ &> ${node}.log
done
