#!/bin/bash
#
# @brief   Remove empty leading spaces from an ascii file
#          and replace input file
# @version ver.1.0
# @date    Sun Oct 04 22:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RMLEADS=rmleads
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A RMLEADS_USAGE=(
    [TOOL_NAME]="__$UTIL_RMLEADS"
    [ARG1]="[FILES] Name of file"
    [EX-PRE]="# Remove empty leading spaces from an ascii file"
    [EX]="__$UTIL_RMLEADS /data/test.txt"	
)

#
# @brief  Remove empty leading spaces from an ascii file 
#         and replace input file
# @param  Value required name of ascii file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmleads "$FILE_PATH"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __rmleads() {
    local FILES=$@
    if [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Remove leading spaces from ascii file and replace input file"
			printf "$DSTA" "$UTIL_RMLEADS" "$FUNC" "$MSG"
		fi
        local tmp1=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $tmp1 >/dev/null 2>&1' 0
        trap "exit 1" 1 2 3 15
        for a in "${FILES[@]}"
        do
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Checking file [$a]"
				printf "$DQUE" "$UTIL_RMLEADS" "$FUNC" "$MSG"
			fi
            if [ -f "$a" ]; then 
                file "$a" | grep -q text
                local STATUS=$?
                if [ "$STATUS" -eq "$SUCCESS" ]; then
                    sed 's/^[ 	]*//' < "$a" > "$tmp1" && mv "$tmp1" "$a"
                else
					if [ "$TOOL_DBG" == "true" ]; then
                    	MSG="File [$a] is not an ascii type"
						printf "$DSTA" "$UTIL_RMLEADS" "$FUNC" "$MSG"
					fi
					:
                fi
            else
				MSG="Check file [$a]"
				printf "$SEND" "$UTIL_RMLEADS" "$MSG"
            fi
        done
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_RMLEADS" "$FUNC" "Done"
		fi
        return $SUCCESS        
    fi
    __usage $RMLEADS_USAGE
    return $NOT_SUCCESS
}
