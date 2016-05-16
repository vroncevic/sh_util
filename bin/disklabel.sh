#!/bin/bash
#
# @brief   Set label name for mounted disk
# @version ver.1.0
# @date    Fri Oct 16 19:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=disklabel
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[DISK_STRUCTURE] Disk drive and disk label"
    [EX-PRE]="# Set label name for mounted disk"
    [EX]="__$UTIL_NAME \$DISK_STRUCTURE"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Set label name for mounted disk
# @param  Value required structure disk drive and label
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# DISK_STRUCTURE[DISK]=$DISK_DRIVE
# DISK_STRUCTURE[LABEL]=$DISK_LABEL
#
# __disklabel $DISK_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __disklabel() {
	DISK_STRUCTURE=$1
    DISK_DRIVE=${DISK_STRUCTURE[DISK]}
    DISK_LABEL=${DISK_STRUCTURE[LABEL]}
    if [ -n "$DISK_DRIVE" ] && [ -n "$DISK_LABEL" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Set label name for mounted disk]"
        	printf "%s" "Checking disk drive "
		fi
        if [ $(mount | grep -c /mnt/$DISK_LABEL) != 0 ] && [ $(grep -qs /mnt/$DISK_LABEL /proc/mounts) ]; then 
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[ok]"
		        printf "%s\n" "Set label"
			fi
            mlabel -i /dev/$DISK_DRIVE ::$LABEL_NAME
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[not ok]" 
		fi
		LOG[MSG]="Disk drive [$DISK_DRIVE] is not mounted"
		if [ "$TOOL_DEBUG" == "true" ]; then        	
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

