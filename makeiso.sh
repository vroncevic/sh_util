#!/bin/bash
#
# @brief   Make ISO file
# @version ver.1.0
# @date    Mon Jun 02 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=makeiso
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[SOURCE]       Target media for cloning or restoring"
    [ARG2]="[DESTINATION]  Final destination"
    [EX-PRE]="# Creates an ISO disk image from a CD-ROM"
    [EX]="__$TOOL_NAME /dev/sr0 myCD.iso"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Check is media disk in disk reader
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkrom
# CHECK_ROM=$?
#
# if [ $CHECK_ROM -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkrom() {
    STATUS=$(blkid /dev/sr0)
    MATCH_SUBSTRING="TYPE=\"iso9660\""
    if [ $STATUS == *"$MATCH_SUBSTRING"* ]; then
        return $SUCCESS
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
# __make_iso /dev/sr0 myCD.iso
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __makeiso {
    SOURCE=$1
    DESTINATION=$2
    if [ -n "$DESTINATION" ] && [ -n "$SOURCE" ]; then
        printf "%s" "Checking media disk "
        DISKEMPTY=$(__checkrom)
        if [ $DISKEMPTY -eq 0 ]; then
            printf "%s\n" "[ok]"
            dd if=/dev/$SOURCE of=$DESTINATION
            return $SUCCESS
        fi 
        printf "%s\n" "[not ok]"
        printf "%s\n" "Insert media disk"
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
