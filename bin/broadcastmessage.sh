#!/bin/bash
#
# @brief   Broadcast messanger
# @version ver.1.0
# @date    Mon Nov 28 19:02:41 CET 2016
# @company None, free  software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
# 
UTIL_BROADCASTMESSAGE=broadcastmessage
UTIL_BROADCASTMESSAGE_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_BROADCASTMESSAGE_VERSION
UTIL_BROADCASTMESSAGE_CFG=$UTIL/conf/$UTIL_BROADCASTMESSAGE.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/loadutilconf.sh

declare -A BROADCASTMESSAGE_USAGE=(
	[USAGE_TOOL]="__$UTIL_BROADCASTMESSAGE"
	[USAGE_ARG1]="[MESSAGE] Main message"
	[USAGE_ARG2]="[NOTE] Short note with fullname"
	[USAGE_EX_PRE]="# Example sending broadcast message"
	[USAGE_EX]="__$UTIL_BROADCASTMESSAGE \$BM_STRUCTURE"	
)

#
# @brief  Sending broadcast message
# @param  Value required broadcastmessage structure (message and note)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A BM_STRUCTURE=(
# 	[MESSAGE]="Hi all, new git repository is up and running!"
# 	[NOTE]="Best Regards, Vladimir Roncevic"
# )
#
# __broadcastmessage BM_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user 
# else
#   # false
#	# missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __broadcastmessage() {
	local -n BROADCASTMESSAGE_STRUCTURE=$1
	local message=${BROADCASTMESSAGE_STRUCTURE[MESSAGE]}
	local note=${BROADCASTMESSAGE_STRUCTURE[NOTE]}
	if [ -n "$message" ] && [ -n "$note" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Sending broadcast message"
			printf "$DQUE" "$UTIL_BROADCASTMESSAGE" "$FUNC" "$MSG"
		fi
		declare -A configbroadcastmessageutil=()
		__loadutilconf "$UTIL_BROADCASTMESSAGE_CFG" configbroadcastmessageutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			__checktool "${configbroadcastmessageutil[WALL]}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
wall<<EndOfBroadcastMessage
Message: $message
Note: $note
EndOfBroadcastMessage
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Sent broadcast message"
					printf "$DEND" "$UTIL_BROADCASTMESSAGE" "$FUNC" "$MSG"
				fi
				return $SUCCESS
			fi
			return $NOT_SUCCESS
		fi
		return $NOT_SUCCESS
	fi
	__usage BROADCASTMESSAGE_USAGE
	return $NOT_SUCCESS
}

