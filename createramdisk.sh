#!/bin/bash
#
# @brief   Creating RAM disk at location
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=createramdisk
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
    [ARG1]="[MOUNTPT] Mount point"
    [EX-PRE]="# Example creating RAM disk"
    [EX]="__$TOOL_NAME \"/mnt/test/\""	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Creating RAM disk
# @argument Value required path location
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __createramdisk $MOUNTPT
# RAM_CREATED=$?
#
# if [ $RAM_CREATED -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __createramdisk() {
    MOUNTPT=$1
    if [ -n "$MOUNTPT" ]; then
        SIZE=2000            # 2K blocks (change as appropriate)
        BLOCKSIZE=1024       # 1K (1024 byte) block size
        DEVICE=/dev/ram0     # First ram device
        if [ ! -d "$MOUNTPT" ]; then
            printf "%s\n" "Creating directory..."
            mkdir "$MOUNTPT"
        fi
        dd if=/dev/zero of=$DEVICE count=$SIZE bs=$BLOCKSIZE  
        mke2fs $DEVICE
        mount $DEVICE $MOUNTPT
        printf "%s\n" "Set permissions..."
        chmod 777 "$MOUNTPT"
        printf "%s\n" "[$MOUNTPT] now available for use"
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
