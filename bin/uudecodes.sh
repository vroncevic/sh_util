#!/bin/bash
#
# @brief   Decode a binary representation
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_UUDECODES=uudecodes
UTIL_UUDECODES_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_UUDECODES_VERSION}
UTIL_UUDECODES_CFG=${UTIL}/conf/${UTIL_UUDECODES}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A UUDECODES_USAGE=(
	[USAGE_TOOL]="__${UTIL_UUDECODES}"
	[USAGE_ARG1]="[FILE_NAME] Path to binary file"
	[USAGE_EX_PRE]="# Example decode thunderbird binary"
	[USAGE_EX]="__${UTIL_UUDECODES} thunderbird-bin"
)

#
# @brief  Decode a binary representation
# @param  Value required path to file 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __uudecodes $FILE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | missing file | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __uudecodes() {
	local FILE=$1
	if [ -n "${FILE}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="" STATUS
		declare -A config_uudecodes=()
		__load_util_conf "$UTIL_UUDECODES_CFG" config_uudecodes
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local UUDEC=${config_uudecodes[UUDEC]}
			__check_tool "${UUDEC}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				MSG="Checking file [${FILE}]?"
				__info_debug_message_que "$MSG" "$FUNC" "$UTIL_UUDECODES"
				if [ -e "${FILE}" ]; then
					MSG="[ok]"
					__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_UUDECODES"
					MSG="Decoding [${FILE}]!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_UUDECODES"
					eval "${UUDEC} ${FILE}"
					__info_debug_message_end "Done" "$FUNC" "$UTIL_UUDECODES"
					return $SUCCESS
				fi
				MSG="[not ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_UUDECODES"
				MSG="Please check file path [${FILE}]!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_UUDECODES"
				MSG="Force exit!"
				__info_debug_message_end "$MSG" "$FUNC" "$UTIL_UUDECODES"
				return $NOT_SUCCESS
			fi
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_UUDECODES"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_UUDECODES"
		return $NOT_SUCCESS
	fi
	__usage UUDECODES_USAGE
	return $NOT_SUCCESS
}

#
# @brief  Decode a binary representations in folder
# @param  Value required path to file 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __uudecodes_all "$FILE"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | missing file | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __uudecodes_all() {
	local FILE=$1 LINES=$2
	if [ -n "${FILE}" && -n "$LINES" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" UUDEC=${config_uudecodes[UUDEC]}
		__check_tool "${UUDEC}"
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			MSG="Decode a binary representations at [${FILE}/]!"
			__info_debug_message "$MSG" "$FUNC" "$UTIL_UUDECODES"
			for FILEDECODE in *
			do
				local S1=`head -${LINES} ${FILEDECODE} | grep begin | wc -w`
				local S2=`tail -${LINES} ${FILEDECODE} | grep end | wc -w`
				if [ ${S1} -gt 0 ]; then
					if [ ${S2} -gt 0 ]; then
						MSG="Decoding [${FILEDECODE}]!"
						__info_debug_message "$MSG" "$FUNC" "$UTIL_UUDECODES"
						eval "${UUDEC} ${FILEDECODE}"
					fi
				fi
			done
			__info_debug_message_end "Done" "$FUNC" "$UTIL_UUDECODES"
			return $SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_UUDECODES"
		return $NOT_SUCCESS
	fi
	__usage UUDECODES_USAGE
	return $NOT_SUCCESS
}

