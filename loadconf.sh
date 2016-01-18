#!/bin/bash
#
# @brief   Load App/Tool/Script Configuration
# @version ver.1.0
# @date    Mon Sep 20 21:00:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
TOOL_NAME=loadconf
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [EX-PRE]="# Example load configuration"
    [EX]="__$TOOL_NAME \$TOOL_CFG configuration"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Load App/Tool/Script configuration from file
# @param Value required path to file and config array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __loadconf $TOOL_CFG configuration
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __loadconf() {
    TOOL_CFG=$1
    CONFIGURATION="$2"
    if [ -n "$TOOL_CFG" ]; then
        __checkcfg $TOOL_CFG
        CHECK_CFG=$?
        if [ $CHECK_CFG -eq $SUCCESS ]; then
            IFS="="
            while read -r key value
            do
                if [ "$key" == "ADMIN_EMAIL" ]; then
                        eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
        
                if [ "$key" == "LOGGING" ]; then
                        eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
        
                if [ "$key" == "DEBUG" ]; then
                        eval "$CONFIGURATION[$key]=$(printf "'%s' " "$value")"
                fi
            done < $TOOL_CFG
            return $SUCCESS
        fi
        printf "%s\n" "Check configuration file:\n$TOOL_CFG."
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

