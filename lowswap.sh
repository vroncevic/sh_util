#!/bin/bash
#
# @brief   Detecting low swap
# @version ver.1.0
# @date    Wed Sep 30 22:49:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=lowswap
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh
. $TOOL_BIN/sendmail.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[LOW_LIMIT]   An integer referring to MB"
    [ARG2]="[ADMIN_EMAIL] Administrator email address"
    [EX-PRE]="# Checking swap memory, is under 12 MB"
    [EX]="__$TOOL_NAME 12"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Notify when free swap memory is less then n Megabytes
# @params Values required count of MB and Admin email
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __lowswap $MEM_LIMIT $ADMIN_EMAIL
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __lowswap() {
    SWAP_LIMIT=$1
    ADMIN_EMAIL=$2
    if [ -n "$SWAP_LIMIT" ]; then
        printf "%s\n" "Checking SWAP memory..."
        case $SWAP_LIMIT in
                +([0-9]))
                        SWAP_FREE=$(free -mo | grep Swap | { read a b c d; echo $d; })
                        if [[ $SWAP_FREE < $SWAP_LIMIT ]]; then
                            __sendmail "Swap is running low! Less then $SWAP_LIMIT MB." "$ADMIN_EMAIL"
                            return $SUCCESS
                        fi
                        return $NOT_SUCCESS 
                        ;;
                *) 
                        __usage $TOOL_USAGE
                        LOG[MSG]="Wrong argument"
                        __logging $LOG
                        return $NOT_SUCCESS 
                        ;;
        esac
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
