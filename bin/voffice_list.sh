#!/bin/bash
#
# @brief   List VirtualOffice 
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VOFFICE_LIST=voffice_check
UTIL_VOFFICE_LIST_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_VOFFICE_LIST_VERSION}
UTIL_VOFFICE_LIST_CFG=${UTIL}/conf/${UTIL_VOFFICE_LIST}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A VOFFICE_LIST_USAGE=(
	[USAGE_TOOL]="__${UTIL_VOFFICE_LIST}"
	[USAGE_ARG1]="[VM_DISK]  Path to lock file"
	[USAGE_EX_PRE]="# Example running tool"
	[USAGE_EX]="__${UTIL_VOFFICE_LIST} \$VM_DISK"
)

#
# @brief  Get info of VirtualOffice 
# @param  Value required VM disk path
# @retval Success return 0, else return 1
# 
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __voffice_check $VMDIR
# 
function __voffice_check() {
	local VMDIR=$1
	if [ -n "${VMDIR}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None"
		MSG="Checking directory [${VMDIR}/]?"
		__info_debug_message_que "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
		if [ -d "${VMDIR}/" ]; then
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
			if [ -f "${VMDIR}/VMLoginUserInfo" ]; then
				local VBOXUSR=$(cat "${VMDIR}/VMLoginUserInfo")
				printf "$SANS" "Locked by user: ${VBOXUSR}!"
			else
				printf "$SANS" "Free VM!"
			fi
			ls -all -sh ${VMDIR}
			return $SUCCESS
		fi
		MSG="[not ok]"
		__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
		MSG="Create directory [${VMDIR}/]!"
		_info_debug_message "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
		return $NOT_SUCCESS
	fi
	__usage VOFFICE_LIST_USAGE
	return $NOT_SUCCESS
}

#
# @brief  Print content of VirtualOffice directory
# @param  None
# @retval Success return 0, else return 1
# 
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __voffice_list
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# problem with VirtualOffice(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
# 
function __voffice_list() {
	local FUNC=${FUNCNAME[0]} MSG="None" STATUS
	MSG="Checking voffice system!"
	__info_debug_message "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
	declare -A config_voffice_list=()
	__load_util_conf "$UTIL_VOFFICE_LIST_CFG" config_voffice_list
	STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		local STATUSVO1 STATUSVO2 STATUSVO3 STATUSVO4
		__voffice_check ${config_voffice_list[VO1_DISK_PATH]}
		STATUSVO1=$?
		__voffice_check ${config_voffice_list[VO2_DISK_PATH]}
		STATUSVO2=$?
		__voffice_check ${config_voffice_list[VO3_DISK_PATH]}
		STATUSVO3=$?
		__voffice_check ${config_voffice_list[VO4_DISK_PATH]}
		STATUSVO4=$?
		declare -A VMSTATUS=(
			[VM1]=$STATUSVO1 [VM2]=$STATUSVO2 [VM3]=$STATUSVO3 [VM4]=$STATUSVO4
		)
		__check_status VMSTATUS
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			__info_debug_message_end "Done" "$FUNC" "$UTIL_VOFFICE_LIST"
			return $SUCCESS
		fi 
		MSG="Something is wrong, check voffice directories!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
		return $NOT_SUCCESS
	fi
	MSG="Force exit!"
	__info_debug_message_end "$MSG" "$FUNC" "$UTIL_VOFFICE_LIST"
	return $NOT_SUCCESS
}

