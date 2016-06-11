#!/bin/bash
#
# @brief   Record audio from microphone or sound input from the console
# @version ver.1.0
# @date    Tue Mar 03 16:11:32 2016
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RECORDMIC=recordmic
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A RECORDMIC_USAGE=(
    [TOOL_NAME]="__$UTIL_RECORDMIC"
    [ARG1]="[FILE_NAME] Name of media file"
    [EX-PRE]="# Recording from microfon to test.mp3"
    [EX]="__$UTIL_RECORDMIC test.mp3"	
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __recordmic() {
    local FILE_NAME=$1
    if [ -n "$FILE_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local SOX="/usr/bin/sox"
		local LAME="/usr/bin/lame"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Record audio from microphone or sound input from the console"
			printf "$DSTA" "$UTIL_RECORDMIC" "$FUNC" "$MSG"
		fi
        __checktool "$SOX"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			__checktool "$LAME"
			STATUS=$?
			if [ "$STATUS" -eq "$SUCCESS" ]; then
				local C1="$SOX -t ossdsp -w -s -r 44100 -c 2 /dev/dsp -t raw -"
				local C2="$LAME -x -m s - $FILE_NAME"
				eval "$C1 | $C2"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_RECORDMIC" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			MSG="Check tool [$LAME]"
			printf "$SEND" "$UTIL_RECORDMIC" "$MSG"
			return $NOT_SUCCESS
        fi
		MSG="Check tool [$SOX]"
		printf "$SEND" "$UTIL_RECORDMIC" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $RECORDMIC_USAGE
    return $NOT_SUCCESS
}
