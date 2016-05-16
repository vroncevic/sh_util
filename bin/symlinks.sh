#!/bin/bash
#
# @brief   List symbolic links in a directory
# @version ver.1.0
# @date    Mon Oct 12 22:23:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=symlinks
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[DIRECTORY] Directory path"
    [EX-PRE]="# Example listing symlinks"
    [EX]="__$UTIL_NAME /etc"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  List symbolic links in a directory
# @param  Value required directory path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __symlinks "$DIRECTORY"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __symlinks() {
    DIRECTORY=$1
    if [ -n "$DIRECTORY" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[List symbolic links in a directory]"
            printf "%s\n" "Checking directory [$DIRECTORY]"
		fi
        if [ -d "$DIRECTORY" ]; then
            printf "%s\n" "Symbolic links in directory \"$DIRECTORY\""
            for listedfile in "$(find $DIRECTORY -type l)"
            do
                printf "%s\n" " $listedfile"
            done | sort
            printf "%s\n" "Symbolic links in directory \"$DIRECTORY\""
            OLDIFS=$IFS
            IFS=:
            for listedfile in $(find "$DIRECTORY" -type l -printf "%p$IFS")
            do
                printf "%s\n" "$listedfile"
            done | sort
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Check directory [$DIRECTORY]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

