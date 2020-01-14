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
./scylla-gce.sh create

# Copy the RPMs to the machines, install and configure scylla.
./scylla-gce.sh prepare
```

## Using the cluster

Start scylla on all nodes:

```
./scylla-gce.sh foreach 'sudo systemctl start scylla-server'
```

You can use [foreach_gce_machine.sh](./foreach_gce_machine.sh) to execute
arbitrary commands on all nodes.

## Replacing the scylla executable with a new one

```
# Upload `${SCYLLA_REPO}/build/release/scylla` to each nodes.
./scylla-gce.sh upload
```

## Access to the machines

Note that you can use still all the standard `gcloud` commands to manage/access the machines.

## Troubleshooting

Each command that operates on multiple nodes will create a logfile for
each node the command is executed on. The logfiles will be named:
`{node_name}.log`.
