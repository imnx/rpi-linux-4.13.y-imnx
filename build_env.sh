#!/bin/bash
curDir="$(pwd)"
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-gnu-"
make -j8 distclean
make -j8 clean
make -j8 mrproper
cd ${curDir}
/bin/bash
