#!/bin/bash

## AGNi version info
KERNELDIR=`readlink -f .`

export AGNI_VERSION_PREFIX="beta3"
export AGNI_VERSION="v3.0"
sed -i 's/5.4.233/5.4.233/' $KERNELDIR/arch/arm64/configs/agni_*
sed -i 's/v3.0-beta2/v3.0-beta3/' $KERNELDIR/arch/arm64/configs/agni_*

echo "	AGNi Version info loaded."

