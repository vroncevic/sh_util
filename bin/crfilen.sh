#!/bin/bash
#
# @brief   Create a file n bytes size
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=crfilen
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh
. $UTIL/bin/logging.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[CREATE_STRUCTURE] Number of bytes, file name and Character"
    [EX-PRE]="# Example creating a file n bytes large"
    [EX]="__$UTIL_NAME \$CREATE_STRUCTURE"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Create a file of n bytes size
# @param  Value required structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# CREATE_STRUCTURE[NB]=8
# CREATE_STRUCTURE[FN]="test.ini"
# CREATE_STRUCTURE[CH]="D"
#
# __crfilen $CREATE_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __crfilen() {
    CREATE_STRUCTURE=$1
    NBYTES=${CREATE_STRUCTURE[NB]}
    FILENAME=${CREATE_STRUCTURE[FN]}
    CHARACHTER=${CREATE_STRUCTURE[CH]}
    if [ -n "$FILENAME" ] && [ -n "$NBYTES" ] && [ -n "$CHARACHTER" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Create a file n bytes size]"
		fi
        case $NBYTES in
            *[!0-9]*) 
                __usage $TOOL_USAGE
                return $NOT_SUCCESS
                ;;
            *)
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s" "Generating file"
				fi
				:
                ;;
        esac
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "Write to file"
		fi
        COUNTER=0
        while(($COUNTER != $NBYTES))
        do
            echo -n "$CHARACHTER" >> "$FILENAME"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s" "."
			fi
            ((COUNTER++))
        done
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "\n%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

