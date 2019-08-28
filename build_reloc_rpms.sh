#!/bin/bash

source ./config.sh

pushd ${SCYLLA_REPO}
./reloc/build_reloc.sh
./reloc/build_rpm.sh
./reloc/python3/build_reloc.sh
./reloc/python3/build_rpm.sh
popd

pushd ${SCYLLA_TOOLS_JAVA_REPO}
./reloc/build_reloc.sh
./reloc/build_rpm.sh
popd

pushd ${SCYLLA_JMX_REPO}
./reloc/build_reloc.sh
./reloc/build_rpm.sh
popd
