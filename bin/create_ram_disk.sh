#!/bin/bash
#
# @brief   Creating RAM disk at location
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CREATE_RAM_DISK=create_ram_disk
UTIL_CREATE_RAM_DISK_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CREATE_RAM_DISK_VERSION}
UTIL_CREATE_RAM_DISK_CFG=${UTIL}/conf/${UTIL_CREATE_RAM_DISK}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A CREATE_RAM_DISK_USAGE=(
	[USAGE_TOOL]="__${UTIL_CREATE_RAM_DISK}"
	[USAGE_ARG1]="[MOUNTPT] Mount point"
	[USAGE_EX_PRE]="# Example creating RAM disk"
	[USAGE_EX]="__${UTIL_CREATE_RAM_DISK} \"/mnt/test/\""
)

#
# @brief  Creating RAM disk
# @param  Value required path location
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __create_ram_disk "$MOUNTPT"
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
function __create_ram_disk() {
	local MOUNTPT=$1
	if [ -n "${MOUNTPT}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		declare -A config_create_ram_disk=()
		__load_util_conf "$UTIL_CREATE_RAM_DISK_CFG" config_create_ram_disk
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local MAKEFS SIZE BLOCK_SIZE DEVICE
			MAKEFS=${config_create_ram_disk[MKE2FS]}
			SIZE=2000 # 2K blocks (change as appropriate)
			BLOCK_SIZE=1024 # 1K (1024 byte) block SIZE
			DEVICE=${config_create_ram_disk[DEVICE]}
			MSG="Checking directory [${MOUNTPT}]?"
			__info_debug_message_que "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
			if [ ! -d "${MOUNTPT}/" ]; then
				MSG="[not ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
				MSG="Creating directory [${MOUNTPT}]!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
				mkdir "${MOUNTPT}"
			else
				MSG="[ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
			fi
			__check_tool "${MAKEFS}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				dd if=/dev/zero of=${DEVICE} count=${SIZE} bs=${BLOCK_SIZE}
				eval "${MAKEFS} ${DEVICE}"
				MSG="Mounting DEVICE [${DEVICE}] to point [${MOUNTPT}]!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
				eval "mount ${DEVICE} ${MOUNTPT}"
				MSG="Set permission!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
				eval "chmod 777 ${MOUNTPT}"
				__info_debug_message_end "Done" "$FUNC" "$UTIL_CREATE_RAM_DISK"
				return $SUCCESS
			fi
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_CREATE_RAM_DISK"
		return $NOT_SUCCESS
	fi
	__usage CREATE_RAM_DISK_USAGE
	return $NOT_SUCCESS
}

