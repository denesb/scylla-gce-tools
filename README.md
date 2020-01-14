# Scylla GCE Tools

Simplistic scripts to set up a scylla cluster in GCE.


## Prerequisites

A local clone of ([scylla](https://github.com/scylladb/scylla.git),
[scylla-tools-java](https://github.com/scylladb/scylla-tools-java.git) and
[scylla-jmx](https://github.com/scylladb/scylla-jmx.git).

[Google Cloud SDK](https://cloud.google.com/sdk/) installed and ready to use.

## Creating the cluster

```
cp example-config.sh config.sh
```

Edit the config to your liking. Note that you can also just use a
simlink.

```sh
# Build the relocatable packages in each required repository:
./scylla-gce.sh build_reloc

# Creates the GCE VM instances.
./scylla-gce.sh create

# Copy the RPMs to the machines, install and configure scylla.
./scylla-gce.sh prepare
```

Note that `scylla-gce.sh` will use your current environment to invoke
the respective `build-reloc.py` scripts. So make sure you run this
command in an environment where these will succeed.

## Using the cluster

Start scylla on all nodes:

```sh
./scylla-gce.sh foreach 'sudo systemctl start scylla-server'
```

You can use [foreach_gce_machine.sh](./foreach_gce_machine.sh) to execute
arbitrary commands on all nodes.

## Replacing the scylla executable with a new one

```sh
# Upload `${SCYLLA_REPO}/build/release/scylla` to each nodes.
./scylla-gce.sh upload
```

## Access to the machines

Note that you can use still all the standard `gcloud` commands to manage/access the machines.

## Troubleshooting

Each command that operates on multiple nodes will create a logfile for
each node the command is executed on. The logfiles will be named:
`{node_name}.log`.
