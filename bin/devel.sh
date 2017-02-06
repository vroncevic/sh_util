#!/bin/bash
#
# @brief   Debug/Info/Question options, print function formats
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

# Set company name
UTIL_FROM_COMPANY="Frobas"

# Debug/Info print mode
TOOL_DBG="false"

# Logging messages
TOOL_LOG="false"

# Send email notification
TOOL_NOTIFY="false"

# Debug print formats
DSTA="[@Module %s.sh @Func %s] %s\n"
DEND="[@Module %s.sh @Func %s] %s\n\n"
DQUE="[@Module %s.sh @Func %s] %s "
DANS="[@Module %s.sh @Func %s] %s\n"

# Info print formats
SSTA="[%s] %s\n"
SEND="[%s] %s\n\n"
SQUE="[%s] %s "
SANS="%s\n"

# Return, check states
SUCCESS=0
NOT_SUCCESS=1

#
# @brief  Check status structure
# @param  Value required structure with statuses
# @retval Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A STATUS_STRUCT=(
#	[TEST1]=$SUCCESS
#	[TEST2]=$SUCCESS
#	...
#	[TESTN]=$SUCCESS
# )
#
# __check_status STATUS_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __check_status() {
	local -n STATUS_STRUCT=$1
	local NSTATUS=${#STATUS_STRUCT[@]} FUNC=${FUNCNAME[0]} MSG="None" I
	if [ -n "${NSTATUS}" ]; then
		for I in "${!STATUS_STRUCT[@]}"
		do
			if [[ ${STATUS_STRUCT[$I]} -eq $NOT_SUCCESS ]]; then
				return $NOT_SUCCESS
			fi
		done
		return $SUCCESS
	fi
	MSG="Missing argument structure [STATUS_STRUCT]"
	printf "$SEND" "devel" "$FUNC" "$MSG"
	return $NOT_SUCCESS
}

#
# @brief  Check key from key list in string representation
# @params Values required key and key list
# @retval Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# KEYS="debug test verification deploy"
# KEY="test"
#
# __check_key $KEY $KEYS
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __check_key() {
	local KEY=$1 KEYS=$2
	if [[ -n "${KEY}" && -n "${KEYS}" ]]; then
		IFS=' ' read -ra ARRAY_KEYS <<< "$KEYS"
		for EL in "${ARRAY_KEYS[@]}"
		do
			if [[ ${KEY} == ${EL} ]]; then
				return $SUCCESS
			fi
		done
		MSG="Key ${KEY} is not in key list [${KEYS}]"
		printf "$SEND" "devel" "$FUNC" "$MSG"
		return $NOT_SUCCESS
	fi
	MSG="Missing argument(s) [TARGET_KEY] or [LIST_OF_KEYS]"
	printf "$SEND" "devel" "$FUNC" "$MSG"
	return $NOT_SUCCESS
}

#
# @brief  Print question text message
# @params Values required message, parent function name and tool name
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __info_debug_que "$MSG" "$FUNC" "$TOOL"
#
function __info_debug_message_que() {
	local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
	if [[ -n "${MSG}" && -n "${PFUNC}" && -n "${TOOL}" ]]; then
		if [ "${TOOL_DBG}" == "true" ]; then
			printf "$DQUE" "$TOOL" "$PFUNC" "$MSG"
		else
			printf "$SQUE" "$TOOL" "$MSG"
		fi
		return
	fi
	local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
	printf "$SEND" "devel" "$FUNC" "$USAGE_MSG"
}

#
# @brief  Print answer text message
# @params Values required message, parent function name and tool name
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __info_debug_message_ans "$MSG" "$FUNC" "$TOOL"
#
function __info_debug_message_ans() {
	local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
	if [[ -n "${MSG}" && -n "${PFUNC}" && -n "${TOOL}" ]]; then
		if [ "${TOOL_DBG}" == "true" ]; then
			printf "$DANS" "$TOOL" "$PFUNC" "$MSG"
		else
			printf "$SANS" "$MSG"
		fi
		return
	fi
	local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
	printf "$SEND" "devel" "$FUNC" "$USAGE_MSG"
}

#
# @brief  Print standard text message
# @params Values required message, parent function name and tool name
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __info_debug_message "$MSG" "$FUNC" "$TOOL"
#
function __info_debug_message() {
	local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
	if [[ -n "${MSG}" && -n "${PFUNC}" && -n "${TOOL}" ]]; then
		if [ "${TOOL_DBG}" == "true" ]; then
			printf "$DSTA" "$TOOL" "$PFUNC" "$MSG"
		else
			printf "$SSTA" "$TOOL" "$MSG"
		fi
		return
	fi
	local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
	printf "$SEND" "devel" "$FUNC" "$USAGE_MSG"
}

#
# @brief  Print end text message
# @params Values required message, parent function name and tool name
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __info_debug_message_end "$MSG" "$FUNC" "$TOOL"
#
function __info_debug_message_end() {
	local MSG=$1 PFUNC=$2 TOOL=$3 FUNC=${FUNCNAME[0]}
	if [[ -n "${MSG}" && -n "${PFUNC}" && -n "${TOOL}" ]]; then
		if [ "${TOOL_DBG}" == "true" ]; then
			printf "$DEND" "$TOOL" "$PFUNC" "$MSG"
		else
			printf "$SEND" "$TOOL" "$MSG"
		fi
		return
	fi
	local USAGE_MSG="Missing argument(s) [MSG] || [PFUNC] || [TOOL]"
	printf "$SEND" "devel" "$FUNC" "$USAGE_MSG"
}

