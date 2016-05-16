#!/bin/bash
#
# @brief   Creating RAM disk at location
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=createramdisk
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[MOUNTPT] Mount point"
    [EX-PRE]="# Example creating RAM disk"
    [EX]="__$UTIL_NAME \"/mnt/test/\""	
)

#
# @brief  Creating RAM disk
# @param  Value required path location
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __createramdisk "$MOUNTPT"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __createramdisk() {
    MOUNTPT=$1
    if [ -n "$MOUNTPT" ]; then
        SIZE=2000            # 2K blocks (change as appropriate)
        BLOCKSIZE=1024       # 1K (1024 byte) block size
        DEVICE=/dev/ram0     # First ram device
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Creating RAM disk]"
            printf "%s" "Checking directory [$MOUNTPT] "
		fi
        if [ ! -d "$MOUNTPT" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "[not ok]"
            	printf "%s\n" "Creating directory [$MOUNTPT]"
			fi
            mkdir "$MOUNTPT"
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
            printf "%s\n" "[ok]"
		fi
        dd if=/dev/zero of=$DEVICE count=$SIZE bs=$BLOCKSIZE  
        mke2fs "$DEVICE"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "Mounting device [$DEVICE] to point [$MOUNTPT]"
		fi
        mount "$DEVICE" "$MOUNTPT"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "Set permissions"
		fi
        chmod 777 "$MOUNTPT"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

