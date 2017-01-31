#!/bin/bash
#
# @brief   Set label name for mounted disk
# @version ver.1.0
# @date    Fri Oct 16 19:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LABEL=disk_label
UTIL_LABEL_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_LABEL_VERSION}
UTIL_LABEL_CFG=${UTIL}/conf/${UTIL_LABEL}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A LABEL_USAGE=(
	[USAGE_TOOL]="__${UTIL_LABEL}"
	[USAGE_ARG1]="[DISK_STRUCT] Disk drive and disk label"
	[USAGE_EX_PRE]="# Set label name for mounted disk"
	[USAGE_EX]="__${UTIL_LABEL} \$DISK_STRUCT"
)

#
# @brief  Set label name for mounted disk
# @param  Value required structure disk drive and label
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A DISK_STRUCT=(
#	[DISK]=$DRIVE
#	[LABEL]=$LABEL
# )
#
# __disk_label DISK_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument(s) | disk is not mounted
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __disk_label() {
	local -n DISK_STRUCT=$1
	local DRIVE=${DISK_STRUCT[DISK]} LABEL=${DISK_STRUCT[LABEL]}
	if [[ -n "${DRIVE}" && -n "${LABEL}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		declare -A config_disk_label=()
		__load_util_conf "$UTIL_LABEL_CFG" config_disk_label
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local MLAB=${config_disk_label[MLAB]}
			__checktool "${MLAB}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				MSG="Checking disk drive [${LABEL}]?"
				__info_debug_message_que "$MSG" "$FUNC" "$UTIL_LABEL"
				local MNTCHK=$(mount | grep -c /mnt/$LABEL)
				local MNTGRP=$(grep -qs /mnt/${LABEL} /proc/mounts)
				if [ ${MNTCHK} != 0 ] && [ ${MNTGRP} ]; then
					MSG="[ok]"
					__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_LABEL"
					MSG="Set label!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_LABEL"
					eval "${MLAB} -i /dev/${DRIVE} ::${LABEL_NAME}"
					__info_debug_message_end "Done" "$FUNC" "$UTIL_LABEL"
					return $SUCCESS
				fi
				MSG="[not ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_LABEL"
				MSG="Disk drive [${DRIVE}] is not mounted!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_LABEL"
				MSG="Force exit!"
				__info_debug_message_end "$MSG" "$FUNC" "$UTIL_LABEL"
				return $NOT_SUCCESS
			fi
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_LABEL"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_LABEL"
		return $NOT_SUCCESS
	fi
	__usage LABEL_USAGE
	return $NOT_SUCCESS
}

