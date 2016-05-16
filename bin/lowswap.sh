#!/bin/bash
#
# @brief   Detecting low swap
# @version ver.1.0
# @date    Wed Sep 30 22:49:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=lowswap
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[LOW_LIMIT]   An integer referring to MB"
    [ARG2]="[ADMIN_EMAIL] Administrator email address"
    [EX-PRE]="# Checking swap memory, is under 12 MB"
    [EX]="__$UTIL_NAME 12 vladimir.roncevic@frobas.com"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Notify when free swap memory is less then n Megabytes
# @params Values required count of MB and Admin email
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __lowswap "$MEM_LIMIT" "$ADMIN_EMAIL"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __lowswap() {
    SWAP_LIMIT=$1
    ADMIN_EMAIL=$2
    if [ -n "$SWAP_LIMIT" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Checking swap memory]"
		fi
        case $SWAP_LIMIT in
            +([0-9]))
                SWAP_FREE=$(free -mo | grep Swap | { read a b c d; echo $d; })
                if [[ $SWAP_FREE < $SWAP_LIMIT ]]; then
                    __sendmail "Swap is running low! Less then $SWAP_LIMIT MB." "$ADMIN_EMAIL"
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n\n" "[Done]"
					fi
                    return $SUCCESS
                fi
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n" "Swap memory [ok]"
					printf "%s\n\n" "[Done]"
				fi
                return $NOT_SUCCESS 
                ;;
            *) 
                LOG[MSG]="Wrong argument"
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
                return $NOT_SUCCESS 
                ;;
        esac
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

