#!/bin/bash
#
# @brief   Make ISO file
# @version ver.1.0
# @date    Mon Jun 02 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=makeiso
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[SOURCE]       Target media for cloning or restoring"
    [ARG2]="[DESTINATION]  Final destination"
    [EX-PRE]="# Creates an ISO disk image from a CD-ROM"
    [EX]="__$UTIL_NAME /dev/sr0 myCD.iso"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Check is media disk in disk reader
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkrom
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checkrom() {
    STATUS=$(blkid /dev/sr0)
    MATCH_SUBSTRING="TYPE=\"iso9660\""
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Check is media disk in disk reader]"
	fi
    if [ $STATUS == *"$MATCH_SUBSTRING"* ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n\n" "Check type of disk, expected iso9660"
	fi
    return $NOT_SUCCESS
}

#
# @brief  Create ISO disk from direcotry source 
# @params Values required source and destination
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __make_iso "/dev/sr0" "myCD.iso"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __makeiso {
    SOURCE=$1
    DESTINATION=$2
    if [ -n "$DESTINATION" ] && [ -n "$SOURCE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Create ISO disk from direcotry source]"
        	printf "%s" "Checking media disk "
		fi
        DISKEMPTY=$(__checkrom)
        if [ $DISKEMPTY -eq 0 ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[ok]"
			fi
            dd if="$SOURCE" of="$DESTINATION"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi 
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[not ok]"
		fi
		LOG[MSG]="Insert media disk"
		if [ "$TOOL_DEBUG" == "true" ]; then        
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG        
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

