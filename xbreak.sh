#!/bin/bash
#
# @brief   Display an X window message when it's time to take a break
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=xbreak
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/checkx.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[TIME] Life time"
    [EX-PRE]="# Example running __$TOOL"
    [EX]="__$TOOL 5s"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Notify when a particular user has logged in
# @argument Value required name of tool
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __xbreak $TIME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __xbreak() {
    TIME=$1
    if [ -n "$TIME" ]; then
        case $TIME in
                +([0-9]))
                    while :
                    do
                        __checkx "xinit"
                        X=$?
                        if [ $X -eq $SUCCESS ]; then
                                xmessage -center "Time's up! Session will be closed"
                        else
                                printf "%s\n" "Time's up! Session will be closed"
                        fi
                    done 
                    return $SUCCESS
                    ;;
                *) 
                    __usage $TOOL_USAGE
                    LOG[MSG]="Wrong argument"
                    __logging $LOG
                    return $NOT_SUCCESS 
                    ;;
        esac
        return $NOT_SUCCESS 
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
