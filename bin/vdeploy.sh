#!/bin/bash
#
# @brief   Copy new version of tool to deployment zone
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=vdeploy
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[VDEPLOY_STRUCTURE] Version number and pat to dev-dir"
    [EX-PRE]="# Copy tool to deployment zone"
    [EX]="__$UTIL_NAME \$VDEPLOY_STRUCTURE"
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Copy new version of tool to deployment zone 
# @param  Value required, structure VDEPLOY_STRUCTURE
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# VDEPLOY_STRUCTURE[TV]="ver.1.0"
# VDEPLOY_STRUCTURE[DP]="/opt/new_tool/"
#
# __vdeploy $VDEPLOY_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __vdeploy() {
    VDEPLOY_STRUCTURE=$1
    VERSION=${VDEPLOY_STRUCTURE[TV]}
    DEVPATH=${VDEPLOY_STRUCTURE[DP]}
    if [ -n "$VERSION" ] && [ -n "$DEVPATH" ]; then
        SRC="$DEVPATH/src"
        DIST="$DEVPATH/dist"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Copy new version of tool to deployment zone]"
        	printf "%s" "Check development directories"
		fi
        if [[ -d "$SRC/ver.${VERSION}.0" ]] && [[ -d "$DIST" ]]; then 
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[ok]"
	            printf "%s" "Copy tool [$SRC/$VERSION/] to [$DIST/]"
			fi
            cp -R "$SRC/ver.${VERSION}.0/" "$DIST/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[ok]"
	            printf "%s" "Set owner"
			fi
            chown -R root.it "$DIST/"
    		if [ "$TOOL_DEBUG" == "true" ]; then        
				printf "%s\n" "[ok]"
	            printf "%s" "Set permission"
			fi
            chmod -R 770 "$DIST/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "[ok]"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi       
		LOG[MSG]="Check [$SRC] and [$DIST]"
		if [ "$TOOL_DEBUG" == "true" ]; then    
			printf "%s\n" "[not ok]"    
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

