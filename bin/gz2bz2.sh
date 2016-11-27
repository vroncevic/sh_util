#!/bin/bash
#
# @brief   Re-compress a gzip (.gz) file to a bzip2 (.bz2) file
# @version ver.1.0
# @date    Tue Mar 15 19:18:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_GZ2BZ2=gz2bz2
UTIL_GZ2BZ2_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_GZ2BZ2_VERSION
UTIL_GZ2BZ2_CFG=$UTIL/conf/$UTIL_GZ2BZ2.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A GZ2BZ2_USAGE=(
    [TOOL]="__$UTIL_GZ2BZ2"
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
# if [ $STATUS -eq $SUCCESS ]; then
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
			declare -A configgz2bz2util=()
			__loadutilconf "$UTIL_GZ2BZ2_CFG" configgz2bz2util
			local STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				local pv=${configgz2bz2util[PV]}
		        __checktool "$pv"
		        STATUS=$?
		        if [ $STATUS -eq $SUCCESS ]; then
					local GZ="gzip -cd \"$FILE_NAME\""
					local pv="$pv -t -r -b -W -i 5 -B 8M"
					local BZ="bzip2 > \"${FILE_NAME}.tar.bz2\""
		            eval "time $GZ | $pv | $BZ"
					if [ "$TOOL_DBG" == "true" ]; then
						printf "$DEND" "$UTIL_GZ2BZ2" "$FUNC" "Done"
					fi
		            return $SUCCESS
		        fi
		        return $NOT_SUCCESS
			fi
			return $NOT_SUCCESS
        fi
		MSG="Please check file [$FILE_NAME]"
		printf "$SEND" "$UTIL_GZ2BZ2" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $GZ2BZ2_USAGE
    return $NOT_SUCCESS
}

