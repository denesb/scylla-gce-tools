#!/bin/bash

source ./config.sh

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
        --image "centos-7-v20180401" \
        --image-project "centos-cloud" \
        --boot-disk-size "200" \
        --boot-disk-type "pd-standard" \
        --boot-disk-device-name "${node}"
done
