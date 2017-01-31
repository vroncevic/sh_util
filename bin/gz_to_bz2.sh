#!/bin/bash
#
# @brief   Re-compress a gzip (.gz) file to a bzip2 (.bz2) file
# @version ver.1.0
# @date    Tue Mar 15 19:18:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_GZ_TO_BZ2=gz_to_bz2
UTIL_GZ_TO_BZ2_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_GZ_TO_BZ2_VERSION}
UTIL_GZ_TO_BZ2_CFG=${UTIL}/conf/${UTIL_GZ_TO_BZ2}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A GZ_TO_BZ2_USAGE=(
	[USAGE_TOOL]="__${UTIL_GZ_TO_BZ2}"
	[USAGE_ARG1]="[FILE] Name of gzip archive"
	[USAGE_EX_PRE]="# Re-compress a gzip (.gz) file to a bzip2 (.bz2) file"
	[USAGE_EX]="__${UTIL_GZ_TO_BZ2} test.tar.gz"
)

#
# @brief  Re-compress a gzip (.gz) file to a bzip2 (.bz2) file
# @param  Value required name of gzip archive
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __gz_to_bz2 "$FILE"
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
function __gz_to_bz2() {
	local FILE=$1
	if [ -n "${FILE}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None"
		MSG="Re-compress a gzip (.gz) file to a bzip2 (.bz2) file!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_GZ_TO_BZ2"
		if [ -e "${FILE}" ]; then
			local STATUS PV GZ BZ
			declare -A config_gz_to_bz2=()
			__load_util_conf "$UTIL_GZ_TO_BZ2_CFG" config_gz_to_bz2
			STATUS=$? 
			if [ $STATUS -eq $SUCCESS ]; then
				PV=${config_gz_to_bz2[PV]}
				__check_tool "${PV}"
				STATUS=$?
				if [ $STATUS -eq $SUCCESS ]; then
					GZ="gzip -cd \"${FILE}\""
					PV="${PV} -t -r -b -W -i 5 -B 8M"
					BZ="bzip2 > \"${FILE}.tar.bz2\""
					eval "time ${GZ} | ${PV} | ${BZ}"
					__info_debug_message_end "Done" "$FUNC" "$UTIL_GZ_TO_BZ2"
					return $SUCCESS
				fi
				MSG="Force exit!"
				__info_debug_message_end "$MSG" "$FUNC" "$UTIL_GZ_TO_BZ2"
				return $NOT_SUCCESS
			fi
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_GZ_TO_BZ2"
			return $NOT_SUCCESS
		fi
		MSG="Please check file [${FILE}]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_GZ_TO_BZ2"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_GZ_TO_BZ2"
		return $NOT_SUCCESS
	fi
	__usage GZ_TO_BZ2_USAGE
	return $NOT_SUCCESS
}

