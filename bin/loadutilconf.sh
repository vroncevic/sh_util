#!/bin/bash
#
# @brief   Load module configuration
# @version ver.1.0
# @date    Thu May 19 08:58:48 CEST 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
UTIL_LOADUTILCONF=loadutilconf
UTIL_LOADUTILCONF_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LOADUTILCONF_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checkcfg.sh
. $UTIL/bin/devel.sh

declare -A LOADUTILCONF_USAGE=(
    [TOOL]="__$UTIL_LOADUTILCONF"
	[ARG1]="[TOOL_CFG]      Path to config file"
    [ARG2]="[CONFIGURATION] Hash structure for config"
    [EX-PRE]="# Example load configuration"
    [EX]="__$UTIL_LOADUTILCONF \$UTIL_CFG configuration"	
)

#
# @brief  Load module configuration from file
# @params Values required path to file and config structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local UTIL_CFG_TOOL="/opt/newtool.cfg"
# declare -A configuration=()
# __loadutilconf $UTIL_CFG_TOOL configuration
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __loadutilconf() {
    local TOOL_CFG=$1
    local CONFIGURATION="$2"
    if [ -n "$TOOL_CFG" ] && [ -n "$CONFIGURATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Load module configuration"
			printf "$DSTA" "$UTIL_LOADUTILCONF" "$FUNC" "$MSG"
		fi
        __checkcfg "$TOOL_CFG"
        local STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            IFS="="
            while read -r key value
            do
				eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
            done < $TOOL_CFG
			if [ "$TOOL_DBG" == "true" ]; then
		    	printf "$DEND" "$UTIL_LOADUTILCONF" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi
    __usage $LOADUTILCONF_USAGE
    return $NOT_SUCCESS
}

