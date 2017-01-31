#!/bin/bash
#
# @brief   Make ISO file
# @version ver.1.0
# @date    Mon Jun 02 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_MAKE_ISO=make_iso
UTIL_MAKE_ISO_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_MAKE_ISO_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A MAKE_ISO_USAGE=(
	[USAGE_TOOL]="__${UTIL_MAKE_ISO}"
	[USAGE_ARG1]="[SRC] Target media for cloning or restoring"
	[USAGE_ARG2]="[DST]  Final destination"
	[USAGE_EX_PRE]="# Creates an ISO disk image from a CD-ROM"
	[USAGE_EX]="__${UTIL_MAKE_ISO} /dev/sr0 myCD.iso"
)

#
# @brief  Check is media disk in disk reader
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __check_rom
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# expected iso9660 format
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __check_rom() {
	local STATUS=$(blkid /dev/sr0) MATCH_SUBSTRING="TYPE=\"iso9660\""
	local FUNC=${FUNCNAME[0]} MSG="None"
	MSG="Check is media disk in disk reader /dev/sr0 !"
	__info_debug_message "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
	if [ $STATUS == *"$MATCH_SUBSTRING"* ]; then
		__info_debug_message_end "Done" "$FUNC" "$UTIL_MAKE_ISO"
		return $SUCCESS
	fi
	MSG="Please check type of disk, expected iso9660"
	__info_debug_message "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
	MSG="Force exit!"
	__info_debug_message_end "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
	return $NOT_SUCCESS
}

#
# @brief  Create ISO disk from direcotry source 
# @params Values required source and destination
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __make_iso "/dev/sr0" "myCD.iso"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument(s) | media is empty
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __make_iso {
	local SRC=$1 DST=$2
	if [[ -n "${DST}" && -n "${SRC}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		MSG="Checking media disk?"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
		__check_rom
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			__info_debug_message_ans "[ok]" "$FUNC" "$UTIL_MAKE_ISO"
			dd if="${SRC}" of="${DST}"
			__info_debug_message_end "Done" "$FUNC" "$UTIL_MAKE_ISO"
			return $SUCCESS
		fi
		MSG="[not ok]"
		__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
		MSG="Insert media disk!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
		return $NOT_SUCCESS
	fi
	__usage MAKE_ISO_USAGE
	return $NOT_SUCCESS
}

