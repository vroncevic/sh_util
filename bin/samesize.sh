#!/bin/bash
#
# @brief   List files of same size in current dir
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SAMESIZE=samesize
UTIL_SAMESIZE_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_SAMESIZE_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A SAMESIZE_USAGE=(
    [USAGE_TOOL]="__$UTIL_SAMESIZE"
    [USAGE_ARG1]="[DIR_PATH] Directory path"
    [USAGE_EX_PRE]="# List files of same size in dir"
    [USAGE_EX]="__$UTIL_SAMESIZE /data/"	
)

#
# @brief  List files of same size in current dir
# @param  Value required path to directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __samesize $DIR_PATH
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing dir
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __samesize() {
    local DIR_PATH=$1
    if [ -n "$DIR_PATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="List files of same size in current dir"
			printf "$DSTA" "$UTIL_SAMESIZE" "$FUNC" "$MSG"
		fi
        if [ -d "$DIR_PATH" ]; then
            local tmp1=/tmp/tmp.${RANDOM}$$
            trap 'rm -f $tmp1 >/dev/null 2>&1' 0
            trap "exit 2" 1 2 3 15
            for a in $DIR_PATH/*
            do
                local f_size=$(set -- $(ls -l -- "$a"); echo $5)
                find . -maxdepth 1 -type f ! -name "$a" -size ${f_size}c > $tmp1
                [ -s $tmp1 ] && 
                { echo file with same size as file \"$a\": ; cat $tmp1; }
            done
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "$DEND" "$UTIL_SAMESIZE" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		MSG="Please check dir [$DIR_PATH/]"
		printf "$SEND" "$UTIL_SAMESIZE" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage SAMESIZE_USAGE
    return $NOT_SUCCESS
}

