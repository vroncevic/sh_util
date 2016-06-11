#!/bin/bash
#
# @brief   Add info, manual and xtools config for new App/Tool/Script
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ADDNEWTOOL=addnewtool
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_CFG_ADDNEWTOOL=$UTIL/conf/$UTIL_ADDNEWTOOL.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A ADDNEWTOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_ADDNEWTOOL"
    [ARG1]="[TOOL_NAME] Name of App/Tool/Script"
    [EX-PRE]="# Example adding info for Thunderbird"
    [EX]="__$UTIL_ADDNEWTOOL thunderbird"
)

#
# @brief  Create file-structure for new App/Tool/Script
# @param  Value required name of App/Tool/Script
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __addnewtool "$TOOL_NAME"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#	# notify admin | user 
# else
#   # false
#	# missing argument | missing config file | tool already exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __addnewtool() {
    local TOOL_NAME=$1
    if [ -n "$TOOL_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A cfgnewtool=()
		__loadutilconf $UTIL_CFG_ADDNEWTOOL cfgnewtool
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			local TOOL_DIR="${cfgnewtool[TOOLS]}/$TOOL_NAME"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dir [${cfgnewtool[TOOLS]}/]"
				printf "$DQUE" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
			fi
			if [ ! -d "$TOOL_DIR/" ]; then 
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[not exist]"
					MSG="Creating dir [$TOOL_DIR/]"
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
				fi
				mkdir "$TOOL_DIR/"
				local DATE=$(date)
				local T_INFO="$TOOL_DIR/$TOOL_NAME-info.txt"
				local T_MANUAL="$TOOL_DIR/$TOOL_NAME-install-manual.txt"
				local T_XTOOLS="$TOOL_DIR/$TOOL_NAME-install-xtools.cfg"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Creating file [$T_INFO]"
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
				fi
				cat <<EOF>>"$T_INFO"
################################################################################
#
# @tool    $TOOL_NAME
# @company $UTIL_FROM_COMPANY
# @date    $DATE
# @brief   Info
#
################################################################################

EOF
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Creating file [$T_MANUAL]"
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
				fi
				cat <<EOF>>"$T_MANUAL"
################################################################################
#
# @tool    $TOOL_NAME
# @company $UTIL_FROM_COMPANY
# @date    $DATE
# @brief   Manual
#
################################################################################

EOF
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Creating file [$T_XTOOLS]"
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
				fi
				cat <<EOF>>"$T_XTOOLS"
################################################################################
#
# @tool    $TOOL_NAME
# @company $UTIL_FROM_COMPANY
# @date    $DATE
# @brief   Xtools config
#
################################################################################

EOF
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "Set owner"
				fi
				chown -R $cfgnewtool[UNAME].$cfgnewtool[GROUP] "$TOOL_DIR/"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "Set permission"
				fi
				chmod -R 770 "$TOOL_DIR/"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DEND" "$UTIL_ADDNEWTOOL" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[already exist]"
			fi
			MSG="File-structure for [$TOOL_NAME] already exist"
			printf "$SEND" "$UTIL_ADDNEWTOOL" "$MSG"
		fi
		return $NOT_SUCCESS
    fi 
    __usage $ADDNEWTOOL_USAGE
    return $NOT_SUCCESS
}
