#!/bin/bash
#
# @brief   Sort Copies
# @version ver.1.0
# @date    Mon Jul 15 22:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SORTCOPY=sortcopy
UTIL_SORTCOPY_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_SORTCOPY_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A LCP_USAGE=(
    ["TOOL"]="__lcp"
    ["ARG1"]="[EXSTENSION]  File extension"
    ["ARG2"]="[DESTINATION] Final destination for copy process"
    ["EX-PRE"]="# Copy all *.jpg files to directory /opt/"
    ["EX"]="__lcp jpg /opt/"	
)

declare -A DUP_USAGE=(
    ["TOOL"]="__duplicatescounter"
    ["ARG1"]="[FILE_PATH] Sort and count duplicates"
    ["EX-PRE"]="# Sort and count duplicates"
    ["EX"]="__duplicatescounter /opt/test.txt"	
)

#
# @brief  List and copy files by extension
# @params Values required extension and destination
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __lcp "jpg" "/opt/"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | missing dir
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __lcp() {
    local EXSTENSION=$1
    local DESTINATION=$2
    if [ -n "$EXSTENSION" ] && [ -n "$DESTINATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking dir [$DESTINATION/]"
			printf "$DQUE" "$UTIL_SORTCOPY" "$FUNC" "$MSG"
		fi
        if [ -d "$DESTINATION" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[ok]"
			fi
            ls *.$EXSTENSION | xargs -n1 -i cp {} "$DESTINATION"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_SORTCOPY" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        printf "%s\n" "[not ok]"
		MSG="Please check dir [$DESTINATION/]"
		printf "$SEND" "$UTIL_SORTCOPY" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage "$(declare -p LCP_USAGE)"
    return $NOT_SUCCESS
}


#
# @brief  Count duplicates
# @param  Value required file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __duplicatescounter "/opt/test.txt"
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
function __duplicatescounter() {
    local FILE_PATH=$1
    if [ -n "$FILE_PATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking dir [$FILE_PATH/]"
			printf "$DQUE" "$UTIL_SORTCOPY" "$FUNC" "$MSG"
		fi
        if [ -d "$FILE_PATH" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[ok]"
			fi
            sort "$FILE_PATH" | uniq -c
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_SORTCOPY" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        printf "%s\n" "[not ok]"
		MSG="Please check path [$FILE_PATH]"
		printf "$SEND" "$UTIL_SORTCOPY" "$MSG"
        return $NOT_SUCCESS
    fi 
    __usage "$(declare -p DUP_USAGE)"
    return $NOT_SUCCESS
}

