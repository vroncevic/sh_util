#!/bin/bash
#
# @brief   Run shell script on remote server without copying
# @version ver.1.0
# @date    Tue Mar 03 21:44:32 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SSH_CMD=ssh_cmd
UTIL_SSH_CMD_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_SSH_CMD_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A SSH_CMD_USAGE=(
	[USAGE_TOOL]="__${UTIL_SSH_CMD}"
	[USAGE_ARG1]="[SSH_STRUCT] Username, server name and path to script"
	[USAGE_EX_PRE]="# Example running script on remote server"
	[USAGE_EX]="__${UTIL_SSH_CMD} \$SSH_STRUCT"
)

#
# @brief  Run shell script on remote server without copying
# @param  Value required SSH_STRUCT
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A SSH_STRUCT=(
#	[UN]="vroncevic"
#	[SN]="host1"
#	[SC]="test.sh"
# )
#
# __ssh_cmd SSH_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | missing script file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __ssh_cmd() {
	local -n SSH_STRUCT=$1
	local USR=${SSH_STRUCT[UN]} SRV=${SSH_STRUCT[SN]} SCR=${SSH_STRUCT[SC]}
	if [[ -n "${USR}" && -n "${SRV}" && -n "${SCR}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None"
		MSG="Checking script file [${SCR}]?"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_SSH_CMD"
		if [ -f "${SCR}" ]; then
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SSH_CMD"
			ssh ${USR}@${SRV} bash < ${SCR}
			__info_debug_message_end "Done" "$FUNC" "$UTIL_SSH_CMD"
			return $SUCCESS
		fi
		MSG="[not ok]"
		__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SSH_CMD"
		MSG="Please check script file [${SCR}]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_SSH_CMD"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_SSH_CMD"
		return $NOT_SUCCESS
	fi
	__usage SSH_CMD_USAGE
	return $NOT_SUCCESS
}

