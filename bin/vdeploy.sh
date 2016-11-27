#!/bin/bash
#
# @brief   Copy new version of tool to deployment zone
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VDEPLOY=vdeploy
UTIL_VDEPLOY_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VDEPLOY_VERSION
UTIL_VDEPLOY_CFG=$UTIL/conf/$UTIL_VDEPLOY.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A VDEPLOY_USAGE=(
    [TOOL]="__$UTIL_VDEPLOY"
    [ARG1]="[VDEPLOY_STRUCTURE] Version number and path to dev-dir"
    [EX-PRE]="# Copy tool to deployment zone"
    [EX]="__$UTIL_VDEPLOY \$VDEPLOY_STRUCTURE"
)

#
# @brief  Copy new version of tool to deployment zone 
# @param  Value required, structure VDEPLOY_STRUCTURE
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A VDEPLOY_STRUCTURE=()
# VDEPLOY_STRUCTURE[TV]="ver.1.0"
# VDEPLOY_STRUCTURE[DP]="/opt/new_tool/"
#
# __vdeploy $VDEPLOY_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | check dirs
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __vdeploy() {
	local VDEPLOY_STRUCTURE=$1
    local VERSION=${VDEPLOY_STRUCTURE[TV]}
    local DEVPATH=${VDEPLOY_STRUCTURE[DP]}
    if [ -n "$VERSION" ] && [ -n "$DEVPATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configvdeployutil=()
		__loadutilconf "$UTIL_VDEPLOY_CFG" configvdeployutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local SRC="$DEVPATH/src"
			local DIST="$DEVPATH/dist"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dirs [$SRC/ver.${VERSION}.0/] [$DIST/]"
				printf "$DQUE" "$UTIL_VDEPLOY" "$FUNC" "$MSG"
			fi
			if [[ -d "$SRC/ver.${VERSION}.0/" ]] && [[ -d "$DIST/" ]]; then 
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "%s\n" "[ok]"
					MSG="Copy [$SRC/ver.${VERSION}.0/] to [$DIST/]"
					printf "$DSTA" "$UTIL_VDEPLOY" "$FUNC" "$MSG"
				fi
				cp -R "$SRC/ver.${VERSION}.0/" "$DIST/"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DSTA" "$UTIL_VDEPLOY" "$FUNC" "Set owner"
				fi
				local PRFX_CMD="chown -R"
				local OWNER="${configvdeployutil[UID]}.${configvdeployutil[GID]}"
				eval "$PRFX_CMD $OWNER $DIST/"
				if [ "$TOOL_DBG" == "true" ]; then        
					printf "$DSTA" "$UTIL_VDEPLOY" "$FUNC" "Set permission"
				fi
				chmod -R 770 "$DIST/"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DEND" "$UTIL_VDEPLOY" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			printf "%s\n" "[not ok]"
			MSG="Please check dirs [$SRC/ver.${VERSION}.0/] [$DIST/]"
			printf "$SEND" "$UTIL_VDEPLOY" "$MSG"
			return $NOT_SUCCESS
        fi
        return $NOT_SUCCESS
    fi 
    __usage $VDEPLOY_USAGE
    return $NOT_SUCCESS
}

