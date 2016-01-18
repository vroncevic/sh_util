#!/bin/bash
#
# @brief   Set label name for mounted disk
# @version ver.1.0
# @date    Fri Oct 16 19:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=disklabel
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
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[DISK_DRIVE] Disk drive"
    [ARG2]="[DISK_LABEL] Disk label"
    [EX-PRE]="# Set label name for mounted disk"
    [EX]="__$TOOL sdc1 usb-disk"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Set label name for mounted disk
# @argument Value required disk drive
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __disklabel $DISK_DRIVE $DISK_LABEL
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __disklabel() {
    DISK_DRIVE=$1
    DISK_LABEL=$2
    if [ -n "$DISK_DRIVE" ] && [ -n "$DISK_LABEL" ]; then
        printf "%s" "Checking disk drive "
        if [ $(mount | grep -c /mnt/$DISK_LABEL) != 0 ] && [ $(grep -qs /mnt/$DISK_LABEL /proc/mounts) ]; then 
            printf "%s\n" "[ok]"
            printf "%s\n" "Set label..."
            mlabel -i /dev/$DISK_DRIVE ::$LABEL_NAME
            printf "%s\n" "Done..."
            return $SUCCESS
        fi
        printf "%s\n" "[not ok]" 
        printf "%s\n" "Disk drive [$DISK_DRIVE] is not mounted"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
