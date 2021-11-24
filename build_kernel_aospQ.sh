#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
export BUILDJOBS=4

KERNELDIR=`readlink -f .`

DEVICE="MIATOLL"
CONFIG1="agni_atoll_aospQ_defconfig"
export AGNI_BUILD_TYPE="AOSP-Q"
SYNC_CONFIG=1

. $KERNELDIR/AGNi_version.sh
FILENAME="AGNi_kernel-$DEVICE-$AGNI_VERSION_PREFIX-$AGNI_VERSION-$AGNI_BUILD_TYPE.zip"

# AGNi CCACHE SHIFTING TO MIATOLL
export CCACHE_SDM660="0"
export CCACHE_MIATOLL_Q="1"
export CCACHE_MIATOLL_R="0"
export CCACHE_HAYDN="0"
. ~/WORKING_DIRECTORY/ccache_shifter.sh

exit_reset() {
	export CCACHE_SDM660="0"
	export CCACHE_MIATOLL_Q="0"
	export CCACHE_MIATOLL_R="0"
	export CCACHE_HAYDN="0"
	. ~/WORKING_DIRECTORY/ccache_shifter.sh
	sync
	exit
}

if [ -f ~/WORKING_DIRECTORY/AGNi_stamp.sh ]; then
	. ~/WORKING_DIRECTORY/AGNi_stamp.sh
fi
if [ -f ~/WORKING_DIRECTORY/snapdragon_llvm.sh ]; then
	. ~/WORKING_DIRECTORY/snapdragon_llvm.sh
fi

if [ ! -d $COMPILEDIR_ATOLL ]; then
	COMPILEDIR_ATOLL=$KERNELDIR/OUTPUT
fi
mkdir -p $COMPILEDIR_ATOLL
if [ -d $COMPILEDIR_ATOLL/arch/arm64/boot ]; then
	rm -rf $COMPILEDIR_ATOLL/arch/arm64/boot
fi

if [ -d $BUILT_EXPORT ]; then
	READY_ZIP="$BUILT_EXPORT"
else
	READY_ZIP="$KERNELDIR/READY_ZIP"
fi;
mkdir -p $READY_ZIP 2>/dev/null;
if [ -f $READY_ZIP/$FILENAME ]; then
	rm $READY_ZIP/$FILENAME
fi

DIR="BUILT-$DEVICE"
rm -rf $KERNELDIR/$DIR
mkdir -p $KERNELDIR/$DIR
cd $KERNELDIR/

echo ""
echo " ~~~~~ Cross-compiling AGNi kernel $DEVICE ~~~~~"
echo "         VERSION: AGNi $AGNI_VERSION_PREFIX $AGNI_VERSION $AGNI_BUILD_TYPE"
echo ""

rm $COMPILEDIR_ATOLL/.config 2>/dev/null

make O=$COMPILEDIR_ATOLL $CONFIG1
make -j$BUILDJOBS O=$COMPILEDIR_ATOLL

if [ $SYNC_CONFIG -eq 1 ]; then # SYNC CONFIG
	cp -f $COMPILEDIR_ATOLL/.config $KERNELDIR/arch/arm64/configs/$CONFIG1
fi
rm $COMPILEDIR_ATOLL/.config $COMPILEDIR_ATOLL/.config.old 2>/dev/null

if ([ -f $COMPILEDIR_ATOLL/arch/arm64/boot/Image.gz ] && [ -f $COMPILEDIR_ATOLL/arch/arm64/boot/dtbo.img ]); then
	mv $COMPILEDIR_ATOLL/arch/arm64/boot/Image.gz $KERNELDIR/$DIR/Image.gz
	mv $COMPILEDIR_ATOLL/arch/arm64/boot/dtb.img $KERNELDIR/$DIR/dtb.img
	mv $COMPILEDIR_ATOLL/arch/arm64/boot/dtbo.img $KERNELDIR/$DIR/dtbo.img
else
	echo "         ERROR: Cross-compiling AGNi kernel $DEVICE."
	rm -rf $KERNELDIR/$DIR
	exit_reset;
fi

echo ""

###### ZIP Packing
if [ -f $KERNELDIR/$DIR/Image.gz ]; then
	cp -r $KERNELDIR/anykernel3/* $KERNELDIR/$DIR/
	rm -rf $KERNELDIR/$DIR/common/AGNiSound_R0
	cd $KERNELDIR/$DIR/
	zip -rq $READY_ZIP/$FILENAME *
	if [ -f ~/WORKING_DIRECTORY/zipsigner-3.0.jar ]; then
		echo "  Zip Signing...."
		java -jar ~/WORKING_DIRECTORY/zipsigner-3.0.jar $READY_ZIP/$FILENAME $READY_ZIP/$FILENAME-signed 2>/dev/null
		mv $READY_ZIP/$FILENAME-signed $READY_ZIP/$FILENAME
	fi
	rm -rf $KERNELDIR/$DIR
	echo " <<<<< AGNi has been built for $DEVICE !!! >>>>>>"
	echo "         VERSION: AGNi $AGNI_VERSION_PREFIX $AGNI_VERSION $AGNI_BUILD_TYPE"
	echo "            FILE: $FILENAME"
else
	echo " >>>>> AGNi $DEVICE BUILD ERROR <<<<<"
fi

# AGNi CCACHE RESET
export CCACHE_SDM660="0"
export CCACHE_MIATOLL_Q="0"
export CCACHE_MIATOLL_R="0"
export CCACHE_HAYDN="0"
. ~/WORKING_DIRECTORY/ccache_shifter.sh

