#!/bin/bash
#
# @brief   Display an X window message when it's time to take a break
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_XBREAK=xbreak
UTIL_XBREAK_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_XBREAK_VERSION
UTIL_XBREAK_CFG=$UTIL/conf/$UTIL_XBREAK.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/checkx.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A XBREAK_USAGE=(
    [TOOL]="__$UTIL_XBREAK"
    [ARG1]="[TIME] Life time"
    [EX-PRE]="# Example running __$UTIL_XBREAK"
    [EX]="__$UTIL_XBREAK 5s"	
)

#
# @brief  Display an X window message when it's time to take a break
# @papram Value required time
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __xbreak $TIME
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __xbreak() {
    local TIME=$1
    if [ -n "$TIME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configxbreakutil=()
		__loadutilconf "$UTIL_XBREAK_CFG" configxbreakutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local xinit=${configxbreakutil[XINIT]}
			local xmsg=${configxbreakutil[XMSG]}
		    case $TIME in
		        +([0-9]))
		            while :
		            do
		                __checkx "$XMSG"
		                STATUS=$?
		                if [ $STATUS -eq $SUCCESS ]; then
		                    MSG="Time's up! Session will be closed"
		                    eval "$XMSG -center $MSG"
		                else
		                    MSG="Time's up! Session will be closed"
							printf "$DSTA" "$UTIL_XBREAK" "$FUNC" "$MSG"
		                fi
		            done 
					if [ "$TOOL_DBG" == "true" ]; then
						printf "$DEND" "$UTIL_XBREAK" "$FUNC" "Done"
					fi
		            return $SUCCESS
		            ;;
		        *) 
		            __usage $XBREAK_USAGE
		            ;;
		    esac
		    return $NOT_SUCCESS 
		fi
		return $NOT_SUCCESS
    fi
    __usage $XBREAK_USAGE
    return $NOT_SUCCESS
}

