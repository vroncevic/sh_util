#!/bin/bash
#
# @brief   Creating RAM disk at location
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CREATERAMDISK=createramdisk
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A CREATERAMDISK_USAGE=(
    [TOOL_NAME]="__$UTIL_CREATERAMDISK"
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
# if [ "$STATUS" -eq "$SUCCESS" ]; then
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
		local MKE2FS="/sbin/mke2fs"
        local SIZE=2000            # 2K blocks (change as appropriate)
        local BLOCKSIZE=1024       # 1K (1024 byte) block size
        local DEVICE=/dev/ram0     # First ram device
		if [ "$TOOL_DBG" == "true" ]; then
            MSG="Check dir [$MOUNTPT]"
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
		__checktool "$MKE2FS"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			dd if=/dev/zero of=$DEVICE count=$SIZE bs=$BLOCKSIZE  
			eval "$MKE2FS $DEVICE"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Mounting device [$DEVICE] to point [$MOUNTPT]"
				printf "$DSTA" "$UTIL_CREATERAMDISK" "$FUNC" "$MSG"
			fi
			mount "$DEVICE" "$MOUNTPT"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$UTIL_CREATERAMDISK" "$FUNC" "Set permission"
			fi
			chmod 777 "$MOUNTPT"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_CREATERAMDISK" "$FUNC" "Done"
			fi
			return $SUCCESS
		fi
		return $NOT_SUCCESS
    fi
    __usage $CREATERAMDISK_USAGE
    return $NOT_SUCCESS
}
