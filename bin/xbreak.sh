#!/bin/bash
#
# @brief   Display an X window message when it's time to take a break
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=xbreak
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checkx.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TIME] Life time"
    [EX-PRE]="# Example running __$UTIL_NAME"
    [EX]="__$UTIL_NAME 5s"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Show window message when it's time to take a break
# @papram Value required time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __xbreak $TIME
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __xbreak() {
    TIME=$1
    if [ -n "$TIME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Show window message when it's time to take a break]"
		fi
        case $TIME in
            +([0-9]))
                while :
                do
                    __checkx "xinit"
                    STATUS=$?
                    if [ "$STATUS" -eq "$SUCCESS" ]; then
                        xmessage -center "Time's up! Session will be closed"
                    else
                        printf "%s\n" "Time's up! Session will be closed"
                    fi
                done 
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "[Done]"
				fi
                return $SUCCESS
                ;;
            *) 
                __usage $TOOL_USAGE
                ;;
        esac
        return $NOT_SUCCESS 
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

