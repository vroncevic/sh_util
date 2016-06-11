#!/bin/bash
#
# @brief   List VirtualOffice 
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VMINFO=vminfo
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_CFG_VOFFICELIST=$UTIL/conf/$UTIL_VMINFO.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A VMINFO_USAGE=(
    [TOOL_NAME]="__$UTIL_VMINFO"
    [ARG1]="[VM_DISK]  Path to lock file"
    [EX-PRE]="# Example running __$UTIL_VMINFO"
    [EX]="__$UTIL_VMINFO \$VM_DISK"	
)

declare -A LOG=(
    [TOOL]="$UTIL_VMINFO"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Get info of VirtualOffice 
# @param  Value required VM disk path
# @retval Success return 0, else return 1
# 
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __vminfo $VM_DISK_PATH
# 
function __vminfo() {
    local VM_DISK_PATH=$1
    if [ -n "$VM_DISK_PATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking dir [$VM_DISK_PATH/]"
			printf "$DQUE" "$UTIL_VMINFO" "$FUNC" "$MSG"
		fi
        if [ -d "$VM_DISK_PATH" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "%s\n" "[ok]"
			fi
            if [ -f "$VM_DISK_PATH/VMLoginUserInfo" ]; then
                local VBOX_USER=$(cat "$VM_DISK_PATH/VMLoginUserInfo")
                printf "%s\n" "locked by user: $VBOX_USER"
            else
                printf "%s\n" "free"
            fi
            ls -all -sh $VM_DISK_PATH
			return $SUCCESS
        fi 
		if [ "$TOOL_DBG" == "true" ]; then   
			printf "%s\n" "[not ok]"         
		fi
		LOG[MSG]="Check dir [$VM_DISK_PATH]"
		MSG="${LOG[MSG]}"
		printf "$SEND" "$UTIL_VMINFO" "$MSG"
		__logging $LOG
		return $NOT_SUCCESS
    fi 
    __usage $VMINFO_USAGE
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
# __vofficelist
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # problem with VirtualOffice(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
# 
function __vofficelist() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
	if [ "$TOOL_DBG" == "true" ]; then
		MSG="Checking voffice system"
		printf "$DSTA" "$UTIL_VMINFO" "$FUNC" "$MSG"
	fi
	declare -A cfgvofficelist=()
	__loadutilconf $UTIL_CFG_VOFFICELIST cfgvofficelist
	local STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
		__vminfo $cfgvofficelist[VO1_DISK_PATH]
		local STATUS_VO1=$?
		if [ "$STATUS_VO1" -eq "$NOT_SUCCESS" ]; then
			MSG="voffice status [$STATUS_VO1]"
			printf "$SSTA" "$UTIL_VMINFO" "$FUNC" "$MSG"
		fi
		__vminfo $cfgvofficelist[VO2_DISK_PATH]
		local STATUS_VO2=$?
		if [ "$STATUS_VO2" -eq "$NOT_SUCCESS" ]; then
			MSG="voffice2 status [$STATUS_VO2]"
			printf "$SSTA" "$UTIL_VMINFO" "$FUNC" "$MSG"
		fi
		__vminfo $cfgvofficelist[VO3_DISK_PATH]
		local STATUS_VO3=$?
		if [ "$STATUS_VO3" -eq "$NOT_SUCCESS" ]; then
			MSG="voffice3 status [$STATUS_VO3]"
			printf "$SSTA" "$UTIL_VMINFO" "$FUNC" "$MSG"
		fi
		__vminfo $cfgvofficelist[VO4_DISK_PATH]
		local STATUS_VO4=$?
		if [ "$STATUS_VO4" -eq "$NOT_SUCCESS" ]; then
			MSG="voffice4 status [$STATUS_VO4]"
			printf "$SSTA" "$UTIL_VMINFO" "$FUNC" "$MSG"
		fi
		if [ "$STATUS_VO1" -eq "$SUCCESS" ] && 
		[ "$STATUS_VO2" -eq "$SUCCESS" ] && 
		[ "$STATUS_VO3" -eq "$SUCCESS" ] && 
		[ "$STATUS_VO4" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_VMINFO" "$FUNC" "Done"
			fi
			return $SUCCESS
		fi 
		MSG="Something is wrong, check voffice dirs"
		printf "$SEND" "$UTIL_VMINFO" "$MSG"
		return $NOT_SUCCESS
	fi
	return $NOT_SUCCESS
} 
