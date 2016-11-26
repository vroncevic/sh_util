#!/bin/bash
#
# @brief   Add info, manual and xtools config for new App/Tool/Script
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ADDNEWTOOL=addnewtool
UTIL_ADDNEWTOOL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_ADDNEWTOOL_VERSION
UTIL_ADDNEWTOOL_CFG=$UTIL/conf/$UTIL_ADDNEWTOOL.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A ADDNEWTOOL_USAGE=(
    ["TOOL"]="__$UTIL_ADDNEWTOOL"
    ["ARG1"]="[TOOL_TO_ADD] Name of App/Tool/Script"
    ["EX-PRE"]="# Example adding info for Thunderbird"
    ["EX"]="__$UTIL_ADDNEWTOOL thunderbird"
)

#
# @brief  Create file-structure for new App/Tool/Script
# @param  Value required name of App/Tool/Script
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __addnewtool "$TOOL_TO_ADD"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
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
    local TOOL_TO_ADD=$1
    if [ -n "$TOOL_TO_ADD" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configaddnewtoolutil=()
		__loadutilconf $UTIL_ADDNEWTOOL_CFG configaddnewtoolutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local ROOT_TOOL_DIR="${configaddnewtoolutil[TOOLS]}"
			if [ ! -d "$ROOT_TOOL_DIR/" ]; then
				MSG="Please create folder structure $ROOT_TOOL_DIR/"
				printf "$SEND" "$UTIL_ADDNEWTOOL" "$MSG"
				return $NOT_SUCCESS
			fi
			local TOOL_DIR="$ROOT_TOOL_DIR/$TOOL_TO_ADD"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dir [$TOOL_DIR/]"
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
				local T_INFO="$TOOL_DIR/$TOOL_TO_ADD-info.txt"
				local T_MANUAL="$TOOL_DIR/$TOOL_TO_ADD-install-manual.txt"
				local T_XTOOLS="$TOOL_DIR/$TOOL_TO_ADD-install-xtools.cfg"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Creating file [$T_INFO]"
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
				fi
				local INFO_FILE="
################################################################################
#
# @tool    $TOOL_TO_ADD
# @company $UTIL_FROM_COMPANY
# @date    $DATE
# @brief   Info
#
################################################################################
"
				echo -e $INFO_FILE > "$T_INFO"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Creating file [$T_MANUAL]"
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
				fi
				local MANUAL_FILE="
################################################################################
#
# @tool    $TOOL_TO_ADD
# @company $UTIL_FROM_COMPANY
# @date    $DATE
# @brief   Manual
#
################################################################################
"				
				echo -e "$MANUAL_FILE" >"$T_MANUAL"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Creating file [$T_XTOOLS]"
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "$MSG"
				fi
				local XTOOLS_FILE="
################################################################################
#
# @tool    $TOOL_TO_ADD
# @company $UTIL_FROM_COMPANY
# @date    $DATE
# @brief   Xtools config
#
################################################################################
"
				echo -e "$XTOOLS_FILE" >"$T_XTOOLS"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$UTIL_ADDNEWTOOL" "$FUNC" "Set owner"
				fi
				local PRFX_CMD="chown -R"
				local OWNER="${configaddnewtoolutil[UID]}.${configaddnewtoolutil[GID]}"
				eval "$PRFX_CMD $OWNER $TOOL_DIR/"				
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
			MSG="File structure for [$TOOL_TO_ADD] already exist"
			printf "$SEND" "$UTIL_ADDNEWTOOL" "$MSG"
		fi
		return $NOT_SUCCESS
    fi 
    __usage "$(declare -p ADDNEWTOOL_USAGE)"
    return $NOT_SUCCESS
}

