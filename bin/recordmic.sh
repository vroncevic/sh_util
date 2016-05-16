#!/bin/bash
#
# @brief   Record audio from microphone or sound input from the console
# @version ver.1.0
# @date    Tue Mar 03 16:11:32 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=recordmic
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE_NAME] Name of media file"
    [EX-PRE]="# Recording from microfon to test.mp3"
    [EX]="__$UTIL_NAME test.mp3"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Record audio from microphone or sound input from the console
# @param  Value required name of media file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __recordmic "test.mp3"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __recordmic() {
    FILE_NAME=$1
    if [ -n "$FILE_NAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Record audio from microphone or sound input from the console]"
		fi
        __checktool "/usr/bin/sox"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            sox -t ossdsp -w -s -r 44100 -c 2 /dev/dsp -t raw - | lame -x -m s - $FILE_NAME
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Check tool sox"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

