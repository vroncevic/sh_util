#!/bin/bash
#
# @brief   Remove duplicate lines from file or stdin
# @version ver.1.0
# @date    Sun Oct 04 22:28:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RMDUPS=rmdups
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A RMDUPS_USAGE=(
    [TOOL_NAME]="__$UTIL_RMDUPS"
    [ARG1]="[STREAM] stdin or file path"
    [EX-PRE]="# Remove duplicate lines from file or stdin"
    [EX]="__$UTIL_RMDUPS /data/test.txt"	
)

#
# @brief  Remove duplicate lines from file or stdin
# @param  Value required stdin or file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmdups "$FILE_PATH"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __rmdups() {
    local FILES=$@
    if [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Remove duplicate lines from file or stdin"
			printf "$DSTA" "$UTIL_RMDUPS" "$FUNC" "$MSG"
		fi
        if [ -f "$FILES" ]; then
            cat "${FILES[@]}" | {
                awk '!x[$0]++'
            }
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_RMDUPS" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		MSG="Check file(s) [$FILES]"
		printf "$SEND" "$UTIL_RMDUPS" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $RMDUPS_USAGE
    return $NOT_SUCCESS
}
