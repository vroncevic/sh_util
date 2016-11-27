#!/bin/bash
#
# @brief   Converting avi to mp4 media format file
# @version ver.1.0
# @date    Tue Mar 03 17:56:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_AVI2MP4=avi2mp4
UTIL_AVI2MP4_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_AVI2MP4_VERSION
UTIL_AVI2MP4_CFG=$UTIL/conf/$UTIL_AVI2MP4.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/loadutilconf.sh

declare -A AVI2MP4_USAGE=(
    [USAGE_TOOL]="__$UTIL_AVI2MP4"
    [USAGE_ARG1]="[FILE_NAME] Path to AVI file"
    [USAGE_EX_PRE]="# Example converting AVI file"
    [USAGE_EX]="__$UTIL_AVI2MP4 test.avi"	
)

#
# @brief  Converting avi to mp4 media format file
# @param  Value required path of AVI file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local AVI="/home/vroncevic/Music/test.avi"
# __avi2mp4 "$AVI"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | failed to convert file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __avi2mp4() {
    local FILE_NAME=$1
    if [ -n "$FILE_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		declare -A configavi2mp4util=()
		__loadutilconf "$UTIL_AVI2MP4_CFG" configavi2mp4util
		local STATUS=$?
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking file [$FILE_NAME]"
			printf "$DQUE" "$UTIL_AVI2MP4" "$FUNC" "$MSG"
		fi
        if [ -e "$FILE_NAME" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
		    	printf "%s\n" "[ok]"
			fi
            __checktool "$configavi2mp4util[FFMPEG]"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Converting [$FILE_NAME] to MP4 format"
					printf "$DSTA" "$UTIL_AVI2MP4" "$FUNC" "$MSG"
				fi
                eval "$configavi2mp4util[FFMPEG] -i \"$FILE_NAME\" \"$FILE_NAME.mp4\""
				if [ "$TOOL_DBG" == "true" ]; then
                	printf "$DEND" "$UTIL_AVI2MP4" "$FUNC" "Done"
				fi
                return $SUCCESS
            fi
            return $NOT_SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[not ok]"
		fi
		MSG="Please check file [$FILE_NAME]"
		printf "$SEND" "$UTIL_AVI2MP4" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage AVI2MP4_USAGE
    return $NOT_SUCCESS
}

