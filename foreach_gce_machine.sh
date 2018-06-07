#!/bin/bash -x

source ./config.sh

for node in $NODES
do
    gcloud compute ssh --zone=${ZONE} ${node} --command="${@}" &> ${node}.log &
done

wait
