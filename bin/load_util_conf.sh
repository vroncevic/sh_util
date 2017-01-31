#!/bin/bash
#
# @brief   Load module configuration
# @version ver.1.0
# @date    Thu May 19 08:58:48 CEST 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
UTIL_LOAD_UTIL_CONF=load_util_conf
UTIL_LOAD_UTIL_CONF_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LOAD_UTIL_CONF_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_cfg.sh

declare -A LOAD_UTIL_CONF_USAGE=(
	[USAGE_TOOL]="__${UTIL_LOAD_UTIL_CONF}"
	[USAGE_ARG1]="[FILE] Path to config file"
	[USAGE_ARG2]="[CONFIG] Hash structure for config"
	[USAGE_EX_PRE]="# Example load configuration"
	[USAGE_EX]="__${UTIL_LOAD_UTIL_CONF} \$UTIL_CFG configuration"
)

#
# @brief  Load module configuration from file
# @params Values required path to file and config structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local UTIL_CFG_TOOL="/opt/newtool.cfg" STATUS
# declare -A configuration=()
# __load_util_conf $UTIL_CFG_TOOL configuration
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __load_util_conf() {
	local FILE=$1 CONFIG=$2
	if [[ -n "${FILE}" && -n "${CONFIG}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS KEY VALUE
		MSG="Load module configuration!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_LOAD_UTIL_CONF"
		__check_cfg "${FILE}"
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			IFS="="
			while read -r KEY VALUE
			do
				eval "$CONFIG[${KEY}]=$(printf "'%s' " "${VALUE}")"
			done < ${FILE}
			__info_debug_message_end "Done" "$FUNC" "$UTIL_LOAD_UTIL_CONF"
			return $SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_LOAD_UTIL_CONF"
		return $NOT_SUCCESS
	fi
	__usage LOAD_UTIL_CONF_USAGE
	return $NOT_SUCCESS
}

