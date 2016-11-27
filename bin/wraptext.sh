#!/bin/bash
#
# @brief   Wrap text file at 80th column, replace file with the wrapped version
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_WRAPTEXT=wraptext
UTIL_WRAPTEXT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_WRAPTEXT_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A WRAPTEXT_USAGE=(
    [TOOL]="__$UTIL_WRAPTEXT"
    [ARG1]="[PATH] Path to the target(s)"
    [EX-PRE]="# Example running __$UTIL_WRAPTEXT"
    [EX]="__$UTIL_WRAPTEXT /data/"	
)

#
# @brief  Wrap text file at 80th column, replace file with the wrapped version
# @param  Value required file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __wraptext "$FILES"
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
function __wraptext() {
    local FILES=$@
    if [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
        for a in "${FILES[@]}"
        do
            if [ -f "$a" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Processing file [$a]"
					printf "$DSTA" "$UTIL_WRAPTEXT" "$FUNC" "$MSG"
				fi
                fmt -w 80 -s $a > /tmp/$$.tmp
                mv /tmp/$$.tmp $a
            else
				MSG="Check file [$a]"
				printf "$SEND" "$UTIL_WRAPTEXT" "$MSG"
            fi
        done 
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_WRAPTEXT" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $WRAPTEXT_USAGE
    return $NOT_SUCCESS
}

