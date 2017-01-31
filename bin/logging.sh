#!/bin/bash
#
# @brief   Write line message to log file
# @version ver.1.0
# @date    Thu Oct 08 18:55:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LOGGING=logging
UTIL_LOGGING_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LOGGING_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A LOGGING_USAGE=(
	[USAGE_TOOL]="__${UTIL_LOGGING}"
	[USAGE_ARG1]="[LOG] Name of App/Tool/Script, flag, path and message"
	[USAGE_EX_PRE]="# Example write LOG line structure to file"
	[USAGE_EX]="__${UTIL_LOGGING} \$LOG_STRUCTURE"
)

#
# @brief  Write line message to log file
# @param  Value required log structure (name, flag, path, message)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A LOG=(
#	[LOG_TOOL]="wolan"           # Name of App/Tool/Script
#	[LOG_FLAG]="info"            # String flag info/error, type of log message
#	[LOG_PATH]="/opt/wolan/log/" # Path to log file of tool
#	[LOG_MSGE]="Simple log line" # Message content for log line
# )
#
# __logging LOG
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument(s) | wrong argument(s) | check log path
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __logging() {
	local -n LOG=$1
	local LTN=${LOG[LOG_TOOL]} LTF=${LOG[LOG_FLAG]}
	local LTP=${LOG[LOG_PATH]} LTM=${LOG[LOG_MSGE]}
	if [[ -n "${LTN}" && -n "${LTF}" && -n "${LTP}" && -n "${LTM}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" LOG_LINE="None"
		MSG="Checking directory [${LTP}/]?"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_LOGGING"
		if [ ! -d "${LTP}/" ]; then
			MSG="[not exist]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_LOGGING"
			MSG="Creating directory [${LTP}/]!"
			__info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGING"
			mkdir "${LTP}/"
		fi
		if [ -d "${LTP}/" ]; then
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_LOGGING"
			if [ "${LTF}" == "info" ]; then
				MSG="Write info log!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGING"
				LOG_LINE="[`date`] INFO ${LTM} [host: `hostname`]"
			elif [ "${LTF}" == "error" ]; then
				MSG="Write error log!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGING"
				LOG_LINE="[`date`] ERROR ${LTM} [host: `hostname`]"
			else
				__usage LOGGING_USAGE
				return $NOT_SUCCESS
			fi
			echo "${LOG_LINE}" >> "${LTP}/${LTN}.log"
			__info_debug_message_end "Done" "$FUNC" "$UTIL_LOGGING"
			return $SUCCESS
		fi
		MSG="Please check log path [${LTP}/]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_LOGGING"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_LOGGING"
		return $NOT_SUCCESS
	fi
	__usage LOGGING_USAGE
	return $NOT_SUCCESS
}

