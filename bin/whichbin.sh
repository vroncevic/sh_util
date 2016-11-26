#!/bin/bash
#
# @brief   Locate binary executable file 
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_WHICHBIN=whichbin
UTIL_WHICHBIN_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_WHICHBIN_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A WHICHBIN_USAGE=(
    ["TOOL"]="__$UTIL_WHICHBIN"
    ["ARG1"]="[PATH] Path to destionation"
    ["EX-PRE"]="# Example running __$UTIL_WHICHBIN"
    ["EX"]="__$UTIL_WHICHBIN /data/"
)

#
# @brief  Show links
# @param  Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __follow_link "$PATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | not an executable file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __follow_link() {
    local FILE=$1
    if [ -n "$FILE" ]; then
		local FILE=$(which "$FILE")
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$FILE" -eq "$NOT_SUCCESS" ]; then
			MSG="[$FILE] is not an executable"
			printf "$SEND" "$UTIL_WHICHBIN" "$MSG"
			return $NOT_SUCCESS
		fi
		if [ -L "$FILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then        
				MSG="Symbolic Link [$FILE]"
				printf "$DSTA" "$UTIL_WHICHBIN" "$FUNC" "$MSG"
			fi
			cd $(dirname "$FILE")
			__follow_link $(set -- $(ls -l "$FILE"); shift 10; echo "$FILE")
		else
			ls -l $FILE
		fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_WHICHBIN" "$FUNC" "Done"
		fi
		return $SUCCESS
    fi
    return $NOT_SUCCESS
}

#
# @brief  Show links and path to executable
# @param  Value required path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __whichbin "$PATH"
# local STATUS=$?
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
function __whichbin() {
    local FILES=$@
    if [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Locate bin"
			printf "$DSTA" "$UTIL_WHICHBIN" "$FUNC" "$MSG"
		fi
        for a in ${FILES[@]}
        do
            __follow_link "$a"
        done 
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_WHICHBIN" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage "$(declare -p WHICHBIN_USAGE)"
    return $NOT_SUCCESS
}

