#!/bin/bash
#
# @brief   List files of same size in current dir
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=samesize
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# List files of same size in dir"
    [EX]="__$UTIL_NAME /data/"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __samesize() {
    DIR_PATH=$1
    if [ -n "$DIR_PATH" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[List files of same size in current dir]"
		fi
        if [ -d "$DIR_PATH" ]; then
            tmp_1=/tmp/tmp.${RANDOM}$$
            trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
            trap "exit 2" 1 2 3 15
            for a in $DIR_PATH/*
            do
                f_size=$(set -- $(ls -l -- "$a"); echo $5)
                find . -maxdepth 1 -type f ! -name "$a" -size ${f_size}c > $tmp_1
                [ -s $tmp_1 ] && { echo file with same size as file \"$a\": ; cat $tmp_1; }
            done
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Check directory [$DIR_PATH]"
		if [ "$TOOL_DEBUG" == "true" ]; then		
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

