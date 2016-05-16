#!/bin/bash
#
# @brief   Copy tool to folder destination
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=xcopy
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[XCOPY_STRUCTURE] Tool name, version, path and dev-path"
    [EX-PRE]="# Copy tool to folder destination"
    [EX]="__$UTIL_NAME \$XCOPY_STRUCTURE"
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Copy tool to folder destination
# @param  Value required, structure XCOPY_STRUCTURE
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# XCOPY_STRUCTURE[TN]="new_tool"
# XCOPY_STRUCTURE[TV]="ver.1.0"
# XCOPY_STRUCTURE[AP]="/usr/bin/local/"
# XCOPY_STRUCTURE[DP]="/opt/new_tool/"
#
# __xcopy $XCOPY_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __xcopy() {
    XCOPY_STRUCTURE=$1
    TOOLNAME=${XCOPY_STRUCTURE[TN]}
    VERSION=${XCOPY_STRUCTURE[TV]}
    APPPATH=${XCOPY_STRUCTURE[AP]}
    DEVPATH=${XCOPY_STRUCTURE[DP]}
    if [ -n "$TOOLNAME" ] && [ -n "$VERSION" ] && [ -n "$APPPATH" ] && [ -n "$DEVPATH" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Copy tool to folder destination]"
        	printf "%s" "Check directory [$APPPATH/] "
		fi
        if [ -d "$APPPATH" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[ok]"
			fi
			:
        else 
            mkdir "$APPPATH/"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[created]"
			fi
        fi
        APPVERSION="$APPPATH/$VERSION"
        if [ -d "$DEVPATH" ]; then   
            if [ -d "$APPVERSION/" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s" "Clean directory [$APPVERSION/] "
				fi
                rm -rf "$APPVERSION/"
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[ok]"
				fi
            else 
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[nothing to clean]"
				fi
            fi
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Copy tool to destination [$APPPATH/]"
			fi
            cp -R "$DEVPATH/dist/ver.${VERSION}.0/" "$APPPATH/"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        else
            LOG[MSG]="Check directory [$DEVPATH/]"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

