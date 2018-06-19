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

This will install scylla nightly and run `scylla_setup`.

### Benchmarking/Testing RPM(s)

Install the copied rpm(s) copied to the nodes:

```
./foreach_gce_machine.sh 'sudo rpm -i --force my-scylla.rpm'
```

Then start the scylla cluster:

```
./forech_gce_machine.sh 'sudo systemctl start scylla-server'
```

### Benchmarking/Testing a custom scylla repo (DEV_MODE=1):

Install scylla's build dependencies:

```
./forech_gce_machine.sh 'cd scylla; sudo ./install-dependencies.sh'
```

Configure and build scylla:

```
./forech_gce_machine.sh 'cd scylla; python3.4 ./configure.py --enable-dpdk --mode=release --static-boost --compiler=/opt/scylladb/bin/g++-7.3 --python python3.4 --ldflag=-Wl,-rpath=/opt/scylladb/lib64 --cflags=-I/opt/scylladb/include --with-antlr3=/opt/scylladb/bin/antlr3 && ninja-build build/release/scylla'
```

Copy scylla executable to `/tmp` where it will be picked up `systemctl`:

```
./forech_gce_machine.sh 'cp ./scylla/build/release/scylla /tmp'
```

Then start the scylla cluster:

```
./forech_gce_machine.sh 'sudo systemctl start scylla-server'
```

This will start the `/tmp/scylla` executable we "deployed" earlier.

### Access to the machines

Note that you can use still all the standard `gcloud` commands to manage/access the machines.

## Bonus - monitoring

Assumes you have a GCE box already with the [scylla monitoring repo](https://github.com/scylladb/scylla-grafana-monitoring) in the home directory and have docker installed and running.

```
./setup_monitoring.sh
```
