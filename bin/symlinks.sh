#!/bin/bash
#
# @brief   List symbolic links in a directory
# @version ver.1.0
# @date    Mon Oct 12 22:23:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SYMLINKS=symlinks
UTIL_SYMLINKS_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_SYMLINKS_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A SYMLINKS_USAGE=(
    [TOOL]="__$UTIL_SYMLINKS"
    [ARG1]="[DIRECTORY] Directory path"
    [EX-PRE]="# Example listing symlinks"
    [EX]="__$UTIL_SYMLINKS /etc"	
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
# local local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __symlinks() {
    local DIRECTORY=$1
    if [ -n "$DIRECTORY" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
            MSG="Checking dir [$DIRECTORY/]"
			printf "$DQUE" "$UTIL_SYMLINKS" "$FUNC" "$MSG"
		fi
        if [ -d "$DIRECTORY" ]; then
            MSG="Symbolic links in dir [$DIRECTORY]"
			printf "$DSTA" "$UTIL_SYMLINKS" "$FUNC" "$MSG"
            for listedfile in "$(find $DIRECTORY -type l)"
            do
                printf "%s\n" " $listedfile"
            done | sort
            printf "%s\n" "Symbolic links in dir [$DIRECTORY/]"
            local OLDIFS=$IFS
            IFS=:
            for listedfile in $(find "$DIRECTORY" -type l -printf "%p$IFS")
            do
                printf "%s\n" "$listedfile"
            done | sort
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_SYMLINKS" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		MSG="Please check dir [$DIRECTORY/]"
		printf "$SEND" "$UTIL_SYMLINKS" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $SYMLINKS_USAGE
    return $NOT_SUCCESS
}

