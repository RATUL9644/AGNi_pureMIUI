#!/bin/sh

## AGNi version info
KERNELDIR=`readlink -f .`

export AGNI_VERSION_PREFIX="stable"
export AGNI_VERSION="v1.0"
export AGNI_BUILD_TYPE="MIUI"
sed -i 's/v1.0-test4/v1.0-stable/' $KERNELDIR/arch/arm64/configs/agni_*

echo "	AGNi Version info loaded."

# CCACHE SHIFTING
if [ -d ~/.ccache ] && [ -d ~/.ccache_MIATOLL ]; then
	mv ~/.ccache ~/.ccache_SDM660
	mv ~/.ccache_MIATOLL ~/.ccache
	echo "	   C-CACHE was shifted to MIATOLL !"
elif [ -d ~/.ccache_SDM660 ] && [ -d ~/.ccache ]; then
		echo "	   C-CACHE is already set to MIATOLL."
else
	mkdir ~/.ccache_MIATOLL
	echo "	   New C-CACHE created for MIATOLL !"
fi
