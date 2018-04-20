# Scylla GCE Tools

Simplistic scripts to set up a scylla cluster in GCE.

## Quick and dirty tutorial

Assumes you have the [Google Cloud SDK](https://cloud.google.com/sdk/) installed and ready to use.

```
cp example-config.sh config.sh
```

Edit the config to your liking.

```
./create_gce_machines.sh
```

Create symlinks to any `rpm`s you'd like to be copied to the servers.

```
./prep_gce_machines.sh
```

This will install scylla nightly. SSH to each box to install the copied rpm(s):

```
sudo rpm -i --force my-scylla.rpm
```

Then start the scylla cluster (on each box):

```
sudo systemctl start scylla-server
```

## Bonus - monitoring

Assumes you have a GCE box already with the [scylla monitoring repo](https://github.com/scylladb/scylla-grafana-monitoring) in the home directory and have docker installed and running.

```
./setup_monitoring.sh
```
