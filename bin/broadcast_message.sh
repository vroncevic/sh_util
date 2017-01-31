#!/bin/bash
#
# @brief   Broadcast messanger
# @version ver.1.0
# @date    Mon Nov 28 19:02:41 CET 2016
# @company None, free  software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
# 
UTIL_BROADCAST_BMSG=broadcast_message
UTIL_BROADCAST_BMSG_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_BROADCAST_BMSG_VERSION}
UTIL_BROADCAST_BMSG_CFG=${UTIL}/conf/${UTIL_BROADCAST_BMSG}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A BROADCAST_BMSG_USAGE=(
	[USAGE_TOOL]="__${UTIL_BROADCAST_BMSG}"
	[USAGE_ARG1]="[BMSG] Main message for broadcast"
	[USAGE_ARG2]="[NOTE] Short note with fullname"
	[USAGE_EX_PRE]="# Example sending broadcast message"
	[USAGE_EX]="__${UTIL_BROADCAST_BMSG} \$BM_STRUCTURE"
)

#
# @brief  Sending broadcast message
# @param  Value required broadcast_message structure (message and NOTE)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A BM_STRUCTURE=(
#	[BMSG]="Hi all, new git repository is up and running!"
#	[NOTE]="Best Regards, Vladimir Roncevic"
# )
#
# __broadcast_message BM_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __broadcast_message() {
	local -n BM_STRUCT=$1
	local BMSG=${BM_STRUCT[BMSG]} NOTE=${BM_STRUCT[NOTE]}
	if [[ -n "${BMSG}" && -n "${NOTE}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		MSG="Sending broadcast message!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
		declare -A config_broadcast_message=()
		__load_util_conf "$UTIL_BROADCAST_BMSG_CFG" config_broadcast_message
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local WALL MSG_TMP MSG_LINE
			WALL=${config_broadcast_message[WALL]}
			MSG_TMP=${config_broadcast_message[BMSG_TMP_FILE]}
			__check_tool "${WALL}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				while read MSG_LINE
				do
					eval echo "${MSG_LINE}" >> ${MSG_TMP}
				done < ${config_broadcast_message[BMSG_TEMPLATE]}
				eval "${WALL} < ${MSG_TMP}"
				rm -f "${MSG_TMP}"
				MSG="Sent broadcast message!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
				__info_debug_message_end "Done" "$FUNC" "$UTIL_BROADCAST_BMSG"
				return $SUCCESS
			fi
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_BROADCAST_BMSG"
		return $NOT_SUCCESS
	fi
	__usage BROADCAST_BMSG_USAGE
	return $NOT_SUCCESS
}

