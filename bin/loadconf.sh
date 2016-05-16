#!/bin/bash
#
# @brief   Load App/Tool/Script Configuration
# @version ver.1.0
# @date    Mon Sep 20 21:00:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
UTIL_NAME=loadconf
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [EX-PRE]="# Example load configuration"
    [EX]="__$UTIL_NAME \$TOOL_CFG configuration"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Load App/Tool/Script configuration from file
# @params Values required path to file and config array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __loadconf $TOOL_CFG $configuration
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __loadconf() {
    TOOL_CFG=$1
    CONFIGURATION="$2"
    if [ -n "$TOOL_CFG" ] && [ -n "$CONFIGURATION" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Load App/Tool/Script configuration from file]"
		fi
        __checkcfg $TOOL_CFG
        CHECK_CFG=$?
        if [ "$CHECK_CFG" -eq "$SUCCESS" ]; then
            IFS="="
            while read -r key value
            do
                if [ "$key" == "ADMIN_EMAIL" ]; then
                    eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
                if [ "$key" == "LOGGING" ]; then
                    eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
            done < $TOOL_CFG
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
		LOG[MSG]="Check configuration file [$TOOL_CFG]"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

