#!/bin/bash

source ./config.sh

gcloud compute ssh ${MONITORING_NODE} --command="sudo docker stop aalert agraf aprom"
gcloud compute ssh ${MONITORING_NODE} --command="sudo docker rm aalert agraf aprom"
gcloud compute ssh ${MONITORING_NODE} --command="cd scylla-grafana-monitoring && sudo rm -rf myconfig && sudo ./genconfig.py -ns -d ./myconfig/ ${NODES} && sudo ./start-all.sh -s ./myconfig/scylla_servers.yml -n ./myconfig/node_exporter_servers.yml"
