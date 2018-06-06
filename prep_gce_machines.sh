#!/bin/bash -x

source ./config.sh

prep_machine() {
    local node=$1
    shift 1

    echo $node

    gcloud compute scp --zone=${ZONE} ./node_prep.sh ${node}:~/prep.sh
    gcloud compute scp --zone=${ZONE} ./config.sh ${node}:~/config.sh

    if [ $DEV_MODE -ne 1 ]
    then
        for rpm in `ls *.rpm`
        do
            gcloud compute scp --zone=${ZONE} ${rpm} ${node}:~/
        done
    fi

    if [ -e ~/.tmux.conf ]
    then
        gcloud compute scp --zone=${ZONE} ~/.tmux.conf ${node}:~/
    fi

    gcloud compute ssh --zone=${ZONE} ${node} --command="chmod u+x ./prep.sh && ./prep.sh ${node} ${@}"
}

for node in $NODES
do
    prep_machine $node $@ &> ${node}.log &
done

wait
