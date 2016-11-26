#!/bin/bash
#
# @brief   Load App/Tool/Script configuration
# @version ver.1.0
# @date    Mon Sep 20 21:00:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
UTIL_LOADCONF=loadconf
UTIL_LOADCONF_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LOADCONF_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checkcfg.sh
. $UTIL/bin/devel.sh

declare -A LOADCONF_USAGE=(
    ["TOOL"]="__$UTIL_LOADCONF"
    ["ARG1"]="[TOOL_CFG]      Path to config file"
    ["ARG2"]="[CONFIGURATION] Hash structure for config"
    ["EX-PRE"]="# Example load configuration"
    ["EX"]="__$UTIL_LOADCONF \$TOOL_CFG configuration"	
)

#
# @brief  Load App/Tool/Script configuration from file
# @params Values required path to file and config array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local TOOL_CFG="/opt/sometool.cfg"
# declare -A configuration=()
# __loadconf $TOOL_CFG configuration
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __loadconf() {
    local TOOL_CFG=$1
    local CONFIGURATION="$2"
    if [ -n "$TOOL_CFG" ] && [ -n "$CONFIGURATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Loading App/Tool/Script configuration"
			printf "$DSTA" "$UTIL_LOADCONF" "$FUNC" "$MSG"
		fi
        __checkcfg "$TOOL_CFG"
        local STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            IFS="="
            while read -r key value 
            do
                if [ "$key" == "ADMIN_EMAIL" ]; then
                    eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
                if [ "$key" == "LOGGING" ]; then
                    eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
				if [ "$key" == "EMAILING" ]; then
                    eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
            done < $TOOL_CFG
			if [ "$TOOL_DBG" == "true" ]; then
		    	printf "$DEND" "$UTIL_LOADCONF" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi
    __usage "$(declare -p LOADCONF_USAGE)"
    return $NOT_SUCCESS
}

