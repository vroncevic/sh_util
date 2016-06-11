#!/bin/bash
#
# @brief   Make ISO file
# @version ver.1.0
# @date    Mon Jun 02 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_MAKEISO=makeiso
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A MAKEISO_USAGE=(
    [TOOL_NAME]="__$UTIL_MAKEISO"
    [ARG1]="[SOURCE]       Target media for cloning or restoring"
    [ARG2]="[DESTINATION]  Final destination"
    [EX-PRE]="# Creates an ISO disk image from a CD-ROM"
    [EX]="__$UTIL_MAKEISO /dev/sr0 myCD.iso"	
)

#
# @brief  Check is media disk in disk reader
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkrom
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # expected iso9660 format
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checkrom() {
    local STATUS=$(blkid /dev/sr0)
    local MATCH_SUBSTRING="TYPE=\"iso9660\""
    local FUNC=${FUNCNAME[0]}
    local MSG=""
	if [ "$TOOL_DBG" == "true" ]; then
		MSG="Check is media disk in disk reader /dev/sr0"
		printf "$DSTA" "$UTIL_MAKEISO" "$FUNC" "$MSG"
	fi
    if [ $STATUS == *"$MATCH_SUBSTRING"* ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_MAKEISO" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
	MSG="Check type of disk, expected iso9660"
	printf "$SEND" "$UTIL_MAKEISO" "$MSG"
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | media is empty
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __makeiso {
    local SOURCE=$1
    local DESTINATION=$2
    if [ -n "$DESTINATION" ] && [ -n "$SOURCE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking media disk"
			printf "$DQUE" "$UTIL_MAKEISO" "$FUNC" "$MSG"
		fi
        __checkrom
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "%s\n" "[ok]"
			fi
            dd if="$SOURCE" of="$DESTINATION"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DEND" "$UTIL_MAKEISO" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi 
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "%s\n" "[not ok]"
		fi       
		MSG="Insert media disk"
		printf "$SEND" "$UTIL_MAKEISO" "$MSG"
        return $NOT_SUCCESS
    fi 
    __usage $MAKEISO_USAGE
    return $NOT_SUCCESS
}
