#!/bin/bash
#
# @brief   Re-compress a gzip (.gz) file to a bzip2 (.bz2) file
# @version ver.1.0
# @date    Tue Mar 15 19:18:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=gz2bz2
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE_NAME] Name of gzip archive"
    [EX-PRE]="# Re-compress a gzip (.gz) file to a bzip2 (.bz2) file"
    [EX]="__$UTIL_NAME test.tar.gz"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Re-compress a gzip (.gz) file to a bzip2 (.bz2) file
# @param  Value required name of gzip archive
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __gz2bz2 "$FILE_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __gz2bz2() {
    FILE_NAME=$1
    if [ -n "$FILE_NAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Re-compress a gzip (.gz) file to a bzip2 (.bz2) file]"
		fi
        if [ -f "$FILE_NAME" ]; then
            __checktool "/usr/bin/pv"
            STATUS=$?
            if [ "$STATUS" -eq "$SUCCESS" ]; then 
                time gzip -cd "$FILE_NAME" | pv -t -r -b -W -i 5 -B 8M | bzip2 > "${FILE_NAME}.tar.bz2"
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "[Done]"
				fi
                return $SUCCESS
            fi
            return $NOT_SUCCESS
        fi
		LOG[MSG]="Check file [$FILE_NAME]"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

