#!/bin/bash
#
# @brief   Set label name for mounted disk
# @version ver.1.0
# @date    Fri Oct 16 19:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_DISKLABEL=disklabel
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A DISKLABEL_USAGE=(
    [TOOL_NAME]="__$UTIL_DISKLABEL"
    [ARG1]="[DISK_STRUCTURE] Disk drive and disk label"
    [EX-PRE]="# Set label name for mounted disk"
    [EX]="__$UTIL_DISKLABEL \$DISK_STRUCTURE"	
)

#
# @brief  Set label name for mounted disk
# @param  Value required structure disk drive and label
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A DISK_STRUCTURE=()
# DISK_STRUCTURE[DISK]=$DISK_DRIVE
# DISK_STRUCTURE[LABEL]=$DISK_LABEL
#
# __disklabel $DISK_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument(s) | disk is not mounted
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __disklabel() {
	local DISK_STRUCTURE=$1
    local DISK_DRIVE=${DISK_STRUCTURE[DISK]}
    local DISK_LABEL=${DISK_STRUCTURE[LABEL]}
    if [ -n "$DISK_DRIVE" ] && [ -n "$DISK_LABEL" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local MLAB="/usr/bin/mlabel"
		__checktool "$MLAB"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking disk drive"
				printf "$DQUE" "$UTIL_DISKLABEL" "$FUNC" "$MSG"
			fi
			if [ $(mount | grep -c /mnt/$DISK_LABEL) != 0 ] && 
			[ $(grep -qs /mnt/$DISK_LABEL /proc/mounts) ]; then 
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "%s\n" "[ok]"
					MSG="Set label"
					printf "$DSTA" "$UTIL_DISKLABEL" "$FUNC" "$MSG"
				fi
				eval "$MLAB -i /dev/$DISK_DRIVE ::${LABEL_NAME}"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_DISKLABEL" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[not ok]" 
			fi
			MSG="Disk drive [$DISK_DRIVE] is not mounted"
			printf "$SEND" "$UTIL_DISKLABEL" "$MSG"
		fi
        return $NOT_SUCCESS
    fi
    __usage $DISKLABEL_USAGE
    return $NOT_SUCCESS
}

