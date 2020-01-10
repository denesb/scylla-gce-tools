#!/bin/bash

source ./config.sh

pushd ${SCYLLA_REPO}
./install-dependencies.sh
./reloc/build_reloc.sh
./reloc/build_rpm.sh
./reloc/python3/build_reloc.sh
./reloc/python3/build_rpm.sh
popd

pushd ${SCYLLA_TOOLS_JAVA_REPO}
./install-dependencies.sh
./reloc/build_reloc.sh
./reloc/build_rpm.sh
popd

pushd ${SCYLLA_JMX_REPO}
./install-dependencies.sh
./reloc/build_reloc.sh
./reloc/build_rpm.sh
popd
