#!/bin/bash
#
# @brief   List files of same size in current dir
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SAME_SIZE=same_size
UTIL_SAME_SIZE_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_SAME_SIZE_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A SAME_SIZE_USAGE=(
	[USAGE_TOOL]="__${UTIL_SAME_SIZE}"
	[USAGE_ARG1]="[DIR] Directory path"
	[USAGE_EX_PRE]="# List files of same size in dir"
	[USAGE_EX]="__${UTIL_SAME_SIZE} /data/"
)

#
# @brief  List files of same size in current dir
# @param  Value required path to directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __same_size $DIR
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | missing dir
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __same_size() {
	local DIR=$1
	if [ -n "${DIR}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" A
		MSG="Check directory [${DIR}/]?"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
		if [ -d "${DIR}" ]; then
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
			local TMP1=/tmp/tmp.${RANDOM}$$
			trap 'rm -f $TMP1 >/dev/null 2>&1' 0
			trap "exit 2" 1 2 3 15
			for A in ${DIR}/*
			do
				local FSIZE=$(set -- $(ls -l -- "${A}"); echo $5)
				local MDEP="-maxdepth 1" TYPE="-type f !" SIZE="-size ${FSIZE}"
				eval "find . ${MDEP} ${TYPE} -name ${A} ${SIZE} > ${TMP1}"
				[ -s ${TMP1} ] && {
					echo "File with same size as file \"${A}\": ";
					cat ${TMP1};
				}
			done
			__info_debug_message_end "Done" "$FUNC" "$UTIL_SAME_SIZE"
			return $SUCCESS
		fi
		MSG="[not ok]"
		__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
		MSG="Please check directory [${DIR}/]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
		return $NOT_SUCCESS
	fi
	__usage SAME_SIZE_USAGE
	return $NOT_SUCCESS
}

