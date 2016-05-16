#!/bin/bash
#
# @brief   Converting avi to mp4 media format file
# @version ver.1.0
# @date    Tue Mar 03 17:56:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=avi2mp4
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE_NAME] Path to AVI file"
    [EX-PRE]="# Example converting AVI file"
    [EX]="__$UTIL_NAME test.avi"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Converting avi to mp4 media format file
# @param  Value required path of AVI file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __avi2mp4 "$TOOL_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __avi2mp4() {
    FILE_NAME=$1
    if [ -n "$FILE_NAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Converting avi file to mp4 format]"
        	printf "%s" "Checking file [$FILE_NAME] "
		fi
        if [ -f "$FILE_NAME" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n" "[ok]"
			fi
            __checktool "/usr/bin/ffmpeg"
            STATUS=$?
            if [ "$STATUS" -eq "$SUCCESS" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "Converting [$FILE_NAME] to MP4 format"
				fi
                ffmpeg -i "$FILE_NAME" "$FILE_NAME.mp4"
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n\n" "[Done]"
				fi
                return $SUCCESS
            fi
            return $NOT_SUCCESS
        fi
		LOG[MSG]="Check file [$FILE_NAME]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[not ok]"
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

