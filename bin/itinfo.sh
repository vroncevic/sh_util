#!/bin/bash
#
# @brief   Generate new Info file
# @version ver.1.0
# @date    Thu Oct 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=itinfo
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TOOL_NAME] Name of App/Tool/Script"
    [EX-PRE]="# Example creating Info file for Squid"
    [EX]="__$UTIL_NAME squid"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Generating App/Tool/Script info file
# @param  Value required name of App/Tool/Script
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __itinfo "$TOOL_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __itinfo() {
    TOOL_NAME=$1
    if [ -n "$TOOL_NAME" ]; then
        INFO_FILE=$PWD/$TOOL_NAME-instructions
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s" "Checking App/Tool/Script info file "
		fi
        if [ ! -f "$INFO_FILE" ]; then 
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s" "[not exist]"
            	printf "%s\n" "Generating App/Tool/Script info file [$INFO_FILE]"
			fi
            DATE=$(date +"%m-%d-%Y")
            cat <<EOF>>"$INFO_FILE"

###########################################################################
#
# $TOOL_NAME
# Company $DATE
#
###########################################################################

EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Set owner"
			fi
            chown root.root "$INFO_FILE"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "Set permission"
			fi
            chmod 770 "$INFO_FILE"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        else  
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[already exist]"
			fi
            LOG[MSG]="Info file already exist"
            __logging $LOG
            return $NOT_SUCCESS
        fi
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

