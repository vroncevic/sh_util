#!/bin/bash
#
# @brief   Record audio from microphone or sound input from the console
# @version ver.1.0
# @date    Tue Mar 03 16:11:32 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RECORD_MIC=record_mic
UTIL_RECORD_MIC_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_RECORD_MIC_VERSION}
UTIL_RECORD_MIC_CFG=${UTIL}/conf/${UTIL_RECORD_MIC}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A RECORD_MIC_USAGE=(
	[USAGE_TOOL]="__${UTIL_RECORD_MIC}"
	[USAGE_ARG1]="[FILE] Name of media file"
	[USAGE_EX_PRE]="# Recording from microfon to test.mp3"
	[USAGE_EX]="__${UTIL_RECORD_MIC} test.mp3"
)

#
# @brief  Record audio from microphone or sound input from the console
# @param  Value required name of media file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __record_mic "test.mp3"
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
function __record_mic() {
	local FILE=$1
	if [ -n "${FILE}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		declare -A config_record_mic=()
		__load_util_conf "$UTIL_RECORD_MIC_CFG" config_record_mic
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local SOX=${config_record_mic[SOX]} LAME=${config_record_mic[LAME]}
			MSG="Record audio from microphone or sound input from the console!"
			__info_debug_message "$MSG" "$FUNC" "$UTIL_RECORD_MIC"
			__check_tool "${SOX}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				__check_tool "${LAME}"
				STATUS=$?
				if [ $STATUS -eq $SUCCESS ]; then
					local C1 C2
					C1="${SOX} -t ossdsp -w -s -r 44100 -c 2 /dev/dsp -t raw -"
					C2="${LAME} -x -m s - ${FILE}"
					eval "${C1} | ${C2}"
					__info_debug_message_end "Done" "$FUNC" "$UTIL_RECORD_MIC"
					return $SUCCESS
				fi
				MSG="Force exit!"
				__info_debug_message_end "$MSG" "$FUNC" "$UTIL_RECORD_MIC"
				return $NOT_SUCCESS
			fi
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_RECORD_MIC"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_RECORD_MIC"
		return $NOT_SUCCESS
	fi
	__usage RECORD_MIC_USAGE
	return $NOT_SUCCESS
}

