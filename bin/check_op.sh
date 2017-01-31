#!/bin/bash
#
# @brief   Checking operation to be done
# @version ver.1.0
# @date    Thu Apr 28 20:40:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECK_OP=check_op
UTIL_CHECK_OP_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CHECK_OP_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A CHECK_OP_USAGE=(
	[USAGE_TOOL]="__${UTIL_CHECK_OP}"
	[USAGE_ARG1]="[OP] Operation to be done"
	[USAGE_ARG2]="[OPLIST] List of operations"
	[USAGE_EX_PRE]="# Example checking operation"
	[USAGE_EX]="__${UTIL_CHECK_OP} \"restart\" \"\${OPLIST[*]\""
)

#
# @brief  Checking operation to be done
# @params Values required operation and list of operations
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local OP="restart" OPLIST=( start stop restart version )
#
# __check_op "$OP" "${OPLIST[*]}"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __check_op() {
	local OP=$1
	OPLIST=($2)
	if [[ -n "${OP}" && -n "${OPLIST}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" I
		MSG="Checking operation [${OP}]?"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_OP"
		for I in "${OPLIST[@]}"
		do
			if [ "${OP}" == "${I}" ]; then
				__info_debug_message_ans "[ok]" "$FUNC" "$UTIL_CHECK_OP"
				__info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_OP"
				return $SUCCESS
			fi
			:
		done
		__info_debug_message_ans "[not ok]" "$FUNC" "$UTIL_CHECK_OP"
		MSG="Please check operation [${OP}]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_CHECK_OP"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_CHECK_OP"
		return $NOT_SUCCESS
	fi
	__usage CHECK_OP_USAGE
	return $NOT_SUCCESS
}

