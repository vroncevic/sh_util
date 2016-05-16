#!/bin/bash
#
# @brief   Remove empty leading spaces from an ascii file
#          and replace input file
# @version ver.1.0
# @date    Sun Oct 04 22:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=rmleads
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILES] Name of file"
    [EX-PRE]="# Remove empty leading spaces from an ascii file"
    [EX]="__$UTIL_NAME /data/test.txt"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Remove empty leading spaces from an ascii file 
#         and replace input file
# @param  Value required name of ascii file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmleads "$FILE_PATH"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __rmleads() {
    FILES=$@
    if [ -n "$FILES" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Remove empty leading spaces from an ascii file and replace input file]"
		fi
        tmp_1=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
        trap "exit 1" 1 2 3 15
        for a in "${FILES[@]}"
        do
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Checking file [$a]"
			fi
            if [ -f "$a" ]; then 
                file "$a" | grep -q text
                STATUS=$?
                if [ "$STATUS" -eq "$SUCCESS" ]; then
                    sed 's/^[ 	]*//' < "$a" > "$tmp_1" && mv "$tmp_1" "$a"
                else
					if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%s\n" "File [$a] is not an ascii type"
					fi
					:
                fi
            else 
                LOG[MSG]="Check file [$a]"
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
            fi
        done
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS        
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

