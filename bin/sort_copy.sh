#!/bin/bash
#
# @brief   Sort Copies
# @version ver.1.0
# @date    Mon Jul 15 22:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SORT_COPY=sort_copy
UTIL_SORT_COPY_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_SORT_COPY_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A LCP_USAGE=(
	[USAGE_TOOL]="__lcp"
	[USAGE_ARG1]="[EXT]  File extension"
	[USAGE_ARG2]="[DST] Final destination for copy process"
	[USAGE_EX_PRE]="# Copy all *.jpg files to directory /opt/"
	[USAGE_EX]="__lcp jpg /opt/"
)

declare -A DUP_USAGE=(
	[USAGE_TOOL]="__duplicates_counter"
	[USAGE_ARG1]="[FILE] Sort and count duplicates"
	[USAGE_EX_PRE]="# Sort and count duplicates"
	[USAGE_EX]="__duplicates_counter /opt/test.txt"
)

#
# @brief  List and copy files by extension
# @params Values required extension and destination
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __lcp "jpg" "/opt/"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument(s) | missing dir
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __lcp() {
	local EXT=$1 DST=$2
	if [[ -n "${EXT}" && -n "${DST}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None"
		MSG="Checking directory [${DST}/]?"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		if [ -d "${DST}" ]; then
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SORT_COPY"
			ls *.${EXT} | xargs -n1 -i cp {} "${DST}"
			__info_debug_message_end "Done" "$FUNC" "$UTIL_SORT_COPY"
			return $SUCCESS
		fi
		MSG="[not ok]"
		__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		MSG="Please check directory [${DST}/]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		return $NOT_SUCCESS
	fi
	__usage LCP_USAGE
	return $NOT_SUCCESS
}


#
# @brief  Count duplicates
# @param  Value required file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __duplicates_counter "/opt/test.txt"
# local STATUS=$?
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
function __duplicates_counter() {
	local FILE=$1
	if [ -n "${FILE}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None"
		MSG="Checking directory [${FILE}/]?"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		if [ -d "${FILE}" ]; then
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SORT_COPY"
			sort "${FILE}" | uniq -c
			__info_debug_message_end "Done" "$FUNC" "$UTIL_SORT_COPY"
			return $SUCCESS
		fi
		MSG="[not ok]"
		__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		MSG="Please check path [${FILE}]!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_SORT_COPY"
		return $NOT_SUCCESS
	fi 
	__usage DUP_USAGE
	return $NOT_SUCCESS
}

