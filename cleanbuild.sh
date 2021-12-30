#!/bin/bash
export KERNELDIR=`readlink -f .`

if [ -f ~/WORKING_DIRECTORY/AGNi_stamp.sh ]; then
	. ~/WORKING_DIRECTORY/AGNi_stamp.sh
fi
if [ ! -d $COMPILEDIR ]; then
	COUT=$KERNELDIR/OUTPUT
	mkdir $COUT
else
	COUT=$COMPILEDIR
fi

echo "`rm -rf $COUT/*`" > /dev/null
if [ -f $COUT/.config ]; then
	rm -rf $COUT/.*
	rm -rf $COUT/.config
	rm -rf $COUT/.thinlto-cache
fi

echo "   Compile folder EMPTY !"

# AGNi CCACHE RESET
export CCACHE_SDM660="0"
export CCACHE_MIATOLL_Q="0"
export CCACHE_MIATOLL_R="0"
export CCACHE_HAYDN="0"
. ~/WORKING_DIRECTORY/ccache_shifter.sh
