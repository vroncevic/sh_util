#!/bin/bash
#
# @brief   Re-compress a gzip (.gz) file to a bzip2 (.bz2) file
# @version ver.1.0
# @date    Tue Mar 15 19:18:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_GZ2BZ2=gz2bz2
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A GZ2BZ2_USAGE=(
    [TOOL_NAME]="__$UTIL_GZ2BZ2"
    [ARG1]="[FILE_NAME] Name of gzip archive"
    [EX-PRE]="# Re-compress a gzip (.gz) file to a bzip2 (.bz2) file"
    [EX]="__$UTIL_GZ2BZ2 test.tar.gz"	
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __gz2bz2() {
    local FILE_NAME=$1
    if [ -n "$FILE_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Re-compress a gzip (.gz) file to a bzip2 (.bz2) file"
			printf "$DSTA" "$UTIL_GZ2BZ2" "$FUNC" "$MSG"
		fi
        if [ -f "$FILE_NAME" ]; then
			local PV="/usr/bin/pv"
            __checktool "$PV"
            local STATUS=$?
            if [ "$STATUS" -eq "$SUCCESS" ]; then
				local GZ="gzip -cd \"$FILE_NAME\""
				local PV="$PV -t -r -b -W -i 5 -B 8M"
				local BZ="bzip2 > \"${FILE_NAME}.tar.bz2\""
                eval "time $GZ | $PV | $BZ"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_GZ2BZ2" "$FUNC" "Done"
				fi
                return $SUCCESS
            fi
            return $NOT_SUCCESS
        fi
		MSG="Check file [$FILE_NAME]"
		printf "$SEND" "$UTIL_GZ2BZ2" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $GZ2BZ2_USAGE
    return $NOT_SUCCESS
}
