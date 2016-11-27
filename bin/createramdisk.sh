#!/bin/bash
#
# @brief   Creating RAM disk at location
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CREATERAMDISK=createramdisk
UTIL_CREATERAMDISK_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CREATERAMDISK_VERSION
UTIL_CREATERAMDISK_CFG=$UTIL/conf/$UTIL_CREATERAMDISK.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A CREATERAMDISK_USAGE=(
    [TOOL]="__$UTIL_CREATERAMDISK"
    [ARG1]="[MOUNTPT] Mount point"
    [EX-PRE]="# Example creating RAM disk"
    [EX]="__$UTIL_CREATERAMDISK \"/mnt/test/\""
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
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __createramdisk() {
    local MOUNTPT=$1
    if [ -n "$MOUNTPT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configcreateramdiskutil=()
		__loadutilconf "$UTIL_APPSHORTCUT_CFG" configcreateramdiskutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local makefs=$configcreateramdiskutil[MKE2FS]
		    local size=2000            # 2K blocks (change as appropriate)
		    local blocksize=1024       # 1K (1024 byte) block size
		    local device=$configcreateramdiskutil[DEVICE]
			if [ "$TOOL_DBG" == "true" ]; then
		        MSG="Checking dir [$MOUNTPT]"
				printf "$DQUE" "$UTIL_CREATERAMDISK" "$FUNC" "$MSG"
			fi
		    if [ ! -d "$MOUNTPT" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[not ok]"
		        	MSG="Creating directory [$MOUNTPT]"
					printf "$DSTA" "$UTIL_CREATERAMDISK" "$FUNC" "$MSG"
				fi
		        mkdir "$MOUNTPT"
		    fi
			if [ "$TOOL_DBG" == "true" ]; then
		        printf "%s\n" "[ok]"
			fi
			__checktool "$makefs"
			local STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				dd if=/dev/zero of=$device count=$size bs=$blocksize  
				eval "$makefs $device"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Mounting device [$device] to point [$MOUNTPT]"
					printf "$DSTA" "$UTIL_CREATERAMDISK" "$FUNC" "$MSG"
				fi
				eval "mount $device $MOUNTPT"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$UTIL_CREATERAMDISK" "$FUNC" "Set permission"
				fi
				chmod 777 "$MOUNTPT"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_CREATERAMDISK" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
		fi
		return $NOT_SUCCESS
    fi
    __usage $CREATERAMDISK_USAGE
    return $NOT_SUCCESS
}

