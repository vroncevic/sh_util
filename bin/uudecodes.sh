#!/bin/bash
#
# @brief   Decode a binary representation
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=uudecodes
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE_NAME] Path to binary file"
    [EX-PRE]="# Example decode thunderbird binary"
    [EX]="__$UTIL_NAME thunderbird-bin"	
)

#
# @brief  Decode a binary representation
# @param  Value required path to file 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __uudecodes $FILE_PATH (optional)
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __uudecodes() {
    FILE_PATH=$1
	if [ -n "$FILE_PATH" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Decode a binary representation]"
			printf "%s" "Check file path [$FILE_PATH] "
		fi
		if [ -f "$FILE_PATH" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n" "[ok]"
		    	printf "%s\n" "Decoding [$FILE_PATH]"
			fi
		    uudecode $FILE_PATH
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
		    return $SUCCESS
		fi
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[not ok]"
			printf "%s\n\n" "[Error] Check file path [$FILE_PATH]"
		fi
		return $NOT_SUCCESS
	fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Decode a binary representations in folder
# @param  Value required path to file 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __uudecodes_all "$FILE_PATH"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __uudecodes_all() {
    if [ -z "$FILE_PATH" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Decode a binary representations in folder]"
		fi
        for filedecode in *
        do
            search1=`head -$lines $filedecode | grep begin | wc -w`
            search2=`tail -$lines $filedecode | grep end | wc -w`
            if [ "$search1" -gt 0 ]; then
                if [ "$search2" -gt 0 ]; then
					if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%s\n" "Decoding [$filedecode]"
					fi
                    uudecode $filedecode
                fi
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

