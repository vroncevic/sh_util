#!/bin/bash
#
# @brief   Checking configuration file of App/Tool/Script
# @version ver.1.0
# @date    Wed Sep 16 10:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CHECK_CFG=check_cfg
UTIL_CHECK_CFG_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CHECK_CFG_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A CHECK_CFG_USAGE=(
	[USAGE_TOOL]="__${UTIL_CHECK_CFG}"
	[USAGE_ARG1]="[TOOL_CFG] Path to config file"
	[USAGE_EX_PRE]="# Example checking config file"
	[USAGE_EX]="__${UTIL_CHECK_CFG} /etc/sometool.cfg"
)

#
# @brief  Checking configuration file exist/regular/no_empty
# @param  Value required path to configuration file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local FILE="/opt/sometool.cfg" STATUS
# __check_cfg "$FILE"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | config file doesn't exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __check_cfg() {
	local FILE=$1
	if [ -n "${FILE}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None"
		MSG="Checking configuration file [${FILE}]"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_CFG"
		if [[ -e "${FILE}" && -f "${FILE}" && -s "${FILE}" ]]; then
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_CFG"
			__info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_CFG"
			return $SUCCESS
		fi
		MSG="[not ok]"
		__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_CFG"
		MSG="Please check file [${FILE}]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_CHECK_CFG"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_CHECK_CFG"
		return $NOT_SUCCESS
	fi
	__usage CHECK_CFG_USAGE
	return $NOT_SUCCESS
}

