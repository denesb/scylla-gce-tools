# Scylla GCE Tools

Simplistic scripts to set up a scylla cluster in GCE.

## Creating the cluster

Assumes you have the [Google Cloud SDK](https://cloud.google.com/sdk/) installed and ready to use.

```
cp example-config.sh config.sh
```

Edit the config to your liking.
Note that the required repositories ([scylla](https://github.com/scylladb/scylla.git),
[scylla-tools-java](https://github.com/scylladb/scylla-tools-java.git) and
[scylla-jmx](https://github.com/scylladb/scylla-jmx.git) should all have their
respective relocatable rpms built. You can run the [build_reloc_rpms.sh](./build_reloc_rpms.sh)
script to do that for you.

```sh
# Creates the GCE VM instances.
./scylla-gce create

# Copy the RPMs to the machines, install and configure scylla.
./scylla-gce prepare
```

## Using the cluster

Start scylla on all nodes:

```
./scylla-gce foreach 'sudo systemctl start scylla-server'
```

You can use [foreach_gce_machine.sh](./foreach_gce_machine.sh) to execute
arbitrary commands on all nodes.

## Replacing the scylla executable with a new one

Copy your scylla executable to the node on which you wish to replace the
excutable:

```
gcloud compute scp /path/to/your/scylla my-example-node:~/scylla
```

Log on to the machine:

```
gcloud compute ssh my-example-node
```

The remaining commands are to be executed on the node.

Stop scylla:

```
sudo systemctl stop scylla-server
```

Replace the executable:

```
sudo cp ~/scylla /opt/scylladb/libexec/scylla
```

You might want to make a backup of the replaced executable in case
things go wrong and you'd like to revert.

Patch the executable:

```
/opt/scylladb/bin/patchelf --set-interpreter /opt/scylladb/libreloc/ld.so /opt/scylladb/libexec/scylla
```

Then start scylla:

```
sudo systemctl start scylla-server
```

## Access to the machines

Note that you can use still all the standard `gcloud` commands to manage/access the machines.

## Troubleshooting

Each script that executes commands on multiple nodes (prepare and
foreach) will create a logfile for each node the command is executed on.
The logfiles will be named: `{node_name}.log`.

## Bonus - monitoring

Assumes you have a GCE box already with the [scylla monitoring repo](https://github.com/scylladb/scylla-grafana-monitoring) in the home directory and have docker installed and running.

```
./setup_monitoring.sh
```
